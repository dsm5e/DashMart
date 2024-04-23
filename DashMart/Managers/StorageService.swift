//
//  StorageService.swift
//  NewsToDay
//
//  Created by Victor on 16.04.2024.
//

import Foundation
import FirebaseDatabase
import SwiftUI
import FirebaseStorage

final actor StorageService: ObservableObject {
    static let shared = StorageService()
    
    private var userId: String? {
        AuthorizeService.shared.userId
    }
    
    private let storage = Storage.storage().reference()
    private var userName: String?
    private var userEmail: String?
    
    @MainActor @Published private(set) var wishlistIds = [Int]()
    @MainActor @Published private(set) var cart = [Int: Int]()
    @MainActor @Published private(set) var selectedCardIds = Set<Int>()
    @MainActor @Published private(set) var avatarImage: UIImage? 
    
    @MainActor var cartCount: Int {
        cart.reduce(0) {
            $0 + $1.value
        }
    }
    
    var needToShowOnbording: Bool {
        get {
            UserDefaults.standard.bool(forKey: "needToShowOnbording")
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "needToShowOnbording")
        }
    }
    
    private init() {
        Task {
            await reload()
        }
    }
    
    func reload() async {
        await getWishlist()
        await getCart()
    }
    
    func logout() async {
        try? await save()
        userName = nil
        userEmail = nil
        await MainActor.run {
            wishlistIds = []
            cart = [:]
        }
        
    }
    
    func getUserName() async throws -> String? {
        guard let userId else {
            return nil
        }
        
        if let userName {
            return userName
        }
        
        let ref = Database.database().reference().child("users").child(userId).child("username")
        guard let snapshot = try? await ref.getData() else {
            return nil
        }
        userName = snapshot.value as? String
        return userName
    }
    
    func setUserName(_ name: String) async throws {
        guard let userId else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userId)
        _ = try? await ref.updateChildValues(["username": name])
    }
    
    func getUserEmail() async throws -> String? {
        guard let userId else {
            return nil
        }
        
        if let userEmail {
            return userEmail
        }
        
        let ref = Database.database().reference().child("users").child(userId).child("email")
        guard let snapshot = try? await ref.getData() else {
            return nil
        }
        userEmail = snapshot.value as? String
        return userEmail
    }
    
    @MainActor
    func addToWishlist(_ id: Int) async throws {
        guard !wishlistIds.contains(id) else {
            return
        }
        wishlistIds.append(id)
    }
    
    @MainActor
    func removeFromWishlist(_ id: Int) async throws {
        wishlistIds.removeAll(where: { $0 == id })
    }
    
    @MainActor
    func saveWishlist() async throws {
        guard let userId = await self.userId else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userId)
        try await ref.updateChildValues(["wishlist": wishlistIds])
    }
    
    @MainActor
    @discardableResult
    func getWishlist() async -> [Int] {
        
        guard let userId = await self.userId else {
            return []
        }
        
        if !wishlistIds.isEmpty {
            return wishlistIds
        }
        
        let ref = Database.database().reference().child("users").child(userId).child("wishlist")
        guard let snapshot = try? await ref.getData() else {
            return []
        }
        guard let ids = snapshot.value as? [Int] else {
            return []
        }
        wishlistIds = ids
        return wishlistIds
    }
    
    func setNeedToShowOnbording(_ value: Bool) {
        needToShowOnbording = value
    }
    
    @MainActor
    func addToCart(_ id: Int) {
        cart[id] = cart[id, default: 0] + 1
    }
    
    @MainActor
    func removeFromCart(_ id: Int) {
        if let amount = cart[id], amount > 1 {
            cart[id] = amount - 1
        } else {
            totalRemoveFromCart(id)
        }
    }
    
    @MainActor
    func totalRemoveFromCart(_ id: Int) {
        cart[id] = nil
        removeSelectedCardId(id)
    }
    
    @MainActor
    func saveCart() async throws {
        guard let userId = await self.userId else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userId)
        let mCart = Dictionary(uniqueKeysWithValues: cart.map { (String($0.key), $0.value) })
        try await ref.updateChildValues(["cart": mCart])
    }
    
    @MainActor
    func getCart() async {
        guard let userId = await self.userId else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userId).child("cart")
        guard let snapshot = try? await ref.getData() else {
            return
        }
        guard let ids = snapshot.valueInExportFormat() as? [String: Int] else {
            return
        }
        cart = Dictionary(uniqueKeysWithValues: ids.map { (Int($0.key)!, $0.value) })
    }
    
    @MainActor
    func save() async throws {
        _ = await (try saveCart(), try saveWishlist())
    }
    
    @MainActor
    func setBuyNowId(_ id: Int) {
        selectedCardIds = [id]
    }
    
    @MainActor
    func addSelectedCardId(_ id: Int) {
        selectedCardIds.insert(id)
    }
    
    @MainActor
    func removeSelectedCardId(_ id: Int) {
        selectedCardIds.remove(id)
    }
    
    // MARK: - Storing the avatar image
    enum StorageError: Error {
        case imageDataConversionFailed, invalidUserId, resizingError
    }
    
    @MainActor
    func setAvatarImage(_ image: UIImage) async throws {
        avatarImage = image
        let imageData = try await convertImageToData(image: image)
        try await saveAvatarImageToTheStorage(imageData)
    }
    
    @MainActor
    private func convertImageToData(image: UIImage) async throws -> Data {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.imageDataConversionFailed
        }
        return imageData
    }
    
    @MainActor
    func saveAvatarImageToTheStorage(_ data: Data) async throws {
        guard let userId = await self.userId else {
            throw URLError(.userAuthenticationRequired)
        }
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "images/\(userId).jpeg"
        let returnedMetaData = try await storage.child(path).putDataAsync(data)
        guard let returnedPath = returnedMetaData.path, let returnedName  = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
    }
    
    @MainActor
    func getAvatarImage() async throws -> UIImage? {
        guard let userId = await self.userId else {
            throw StorageError.invalidUserId
        }
        
        let path = "images/\(userId).jpeg"
        var avaterImage: UIImage? = nil
        let data = try await storage.child(path).data(maxSize: 1 * 1024 * 1024)
        let image = UIImage(data: data)
        avaterImage = image
        return avaterImage
    }
    
    @MainActor
    func deleteAvatarImage() async throws {
        guard let userId = await self.userId else {
            throw StorageError.invalidUserId
        }
        
        let path = "images/\(userId).jpeg"
        try await storage.child(path).delete()
    }
    
    
    // MARK: - SearchResult
    // TODO: - implement firebase
    @MainActor
    var searchHistory: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "SearchHistory") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SearchHistory")
        }
    }
    
    func clearSearchHistory() {
        Task {
            UserDefaults.standard.set([], forKey: "SearchHistory")
        }
    }
}
