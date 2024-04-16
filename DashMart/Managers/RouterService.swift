//
//  RouterService.swift
//  NewsToDay
//
//  Created by Victor on 16.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

final class RouterService: ObservableObject {
    
    enum Screen {
        case onbording
        case authorization
        case main
    }
    
    @Published var screen: Screen
    
    private let storage = StorageService.shared
    
    init() {
        guard Auth.auth().currentUser != nil else {
            screen = .authorization
            return
        }
        screen = .main
    }
    
    func openApp() {
        Task {
            @MainActor in
            screen = await storage.needToShowOnbording ? .onbording : .main
            await storage.setNeedToShowOnbording(false)
        }
    }
    
    func openAuth() {
        screen = .authorization
    }
}
