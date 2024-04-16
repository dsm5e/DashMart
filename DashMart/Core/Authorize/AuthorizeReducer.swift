//
//  AuthorizeReducer.swift
//  NewsToDay
//
//  Created by Victor on 16.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class AuthorizeReducer {
    func authorize(email: String, password: String) async throws {
        try await AuthorizeService.shared.authorize(email: email, password: password)
    }
    
    func register(username: String, email: String, password: String) async throws {
        try await AuthorizeService.shared.register(username: username, email: email, password: password)
    }
}
