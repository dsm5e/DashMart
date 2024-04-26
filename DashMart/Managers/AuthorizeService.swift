//
//  AuthorizeService.swift
//  NewsToDay
//
//  Created by Victor on 16.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final actor AuthorizeService {

    static let shared = AuthorizeService()
    
    private init() { }
    
    nonisolated var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    func authorize(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
        await StorageService.shared.reload()
    }
    
    func register(username: String, email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(uid)
        try await ref.setValue(["username": username, "email": email])
        await StorageService.shared.setNeedToShowOnbording(true)
    }
    
    func logout() async -> Bool {
        do {
            await StorageService.shared.logout()
            try Auth.auth().signOut()
            await StorageService.shared.clearSearchHistory()
            return true
        } catch {
            return false
        }
    }
}
