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
    
    nonisolated var currentUser: User? {
        Auth.auth().currentUser
    }
    
    func authorize(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
        await StorageService.shared.reload()
    }
    
    func register(username: String, email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
        guard let uid = currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(uid)
        try await ref.setValue(["username": username, "email": email])
        await StorageService.shared.setNeedToShowOnbording(true)
    }
    
    func changeEmail(email: String) async -> (Bool, String?) {
        guard let currentUser else {
            return (false, nil)
        }
        do {
            let ref = Database.database().reference().child("users").child(currentUser.uid).child("email")
            try await currentUser.updateEmail(to: email)
            try await ref.setValue(email)
            return (true, nil)
        } catch {
            return (false, error.localizedDescription)
        }
    }
    
    func changePassword(password: String) async -> (Bool, String?) {
        guard let currentUser else {
            return (false, nil)
        }
        do {
            try await currentUser.updatePassword(to: password)
            return (true, nil)
        } catch {
            return (false, error.localizedDescription)
        }
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
