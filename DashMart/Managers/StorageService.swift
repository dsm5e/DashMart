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
    private var wishlistIds = [Int]()
    
    var needToShowOnbording: Bool {
        get {
            UserDefaults.standard.bool(forKey: "needToShowOnbording")
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "needToShowOnbording")
        }
    }
    
    private init() { }
    
    func logout() {
        wishlistIds = []
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
    
    func addToWishlist(_ id: Int) async throws {
        var wishlistIds = await getWishlist()
        wishlistIds.append(id)
        try await setWishlist(wishlistIds: wishlistIds)
    }
    
    func removeFromWishlist(_ id: Int) async throws {
        wishlistIds.removeAll(where: { $0 == id })
        try await setWishlist(wishlistIds: wishlistIds)
    }
    
    func setWishlist(wishlistIds: [Int]) async throws {
        guard let userId else {
            return
        }
        
        self.wishlistIds = wishlistIds
        
        let ref = Database.database().reference().child("users").child(userId)
        try await ref.updateChildValues(["wishlist": wishlistIds])
        
    }
    
    func getWishlist() async -> [Int] {
        
        guard let userId else {
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
}
