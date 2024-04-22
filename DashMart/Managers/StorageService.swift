//
//  StorageService.swift
//  NewsToDay
//
//  Created by Victor on 16.04.2024.
//

import Foundation
import FirebaseDatabase
import SwiftUI

final actor StorageService: ObservableObject {
    static let shared = StorageService()
    
    private var userId: String? {
        AuthorizeService.shared.userId
    }
    
    private var userName: String?
    private var userEmail: String?
    
    @MainActor @Published private(set) var wishlistIds = [Int]()
    @MainActor @Published private(set) var basket = [Int: Int]()
    @MainActor var basketCount: Int {
        basket.reduce(0) {
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
            await getWishlist()
            await getBasket()
        }
    }
    
    @MainActor
    func logout() async {
        wishlistIds = []
        try? await saveBasket()
        basket = [:]
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
    func addToBasket(_ id: Int) {
        basket[id] = basket[id, default: 0] + 1
    }
    
    @MainActor
    func removeFromBasket(_ id: Int) {
        if let amount = basket[id], amount > 1 {
            basket[id] = amount - 1
        } else {
            totalRemoveFromBasket(id)
        }
    }
    
    @MainActor
    func totalRemoveFromBasket(_ id: Int) {
        basket[id] = nil
    }
    
    @MainActor
    func saveBasket() async throws {
        guard let userId = await self.userId else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userId)
        let mBasket = Dictionary(uniqueKeysWithValues: basket.map { (String($0.key), $0.value) })
        try await ref.updateChildValues(["basket": mBasket])
    }
    
    @MainActor
    func getBasket() async {
        guard let userId = await self.userId else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userId).child("basket")
        guard let snapshot = try? await ref.getData() else {
            return
        }
        guard let ids = snapshot.valueInExportFormat() as? [String: Int] else {
            return
        }
        basket = Dictionary(uniqueKeysWithValues: ids.map { (Int($0.key)!, $0.value) })
    }
    
    @MainActor
    func save() async throws {
        _ = await (try saveBasket(), try saveWishlist())
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
