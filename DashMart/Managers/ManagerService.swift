//
//  ManagerService.swift
//  DashMart
//
//  Created by Victor on 22.04.2024.
//

import Foundation

final class ManagerService: ObservableObject {
    @Published var isManager: Bool = true
    var needPassword: Bool {
        !wasAuthorizedAsManager
    }
    private var wasAuthorizedAsManager = false
    private var password = "123123"
    
    static let shared = ManagerService()
    
    private init() { }
    
    @discardableResult
    func enterAsManager(_ password: String?) -> Bool {
        guard needPassword else {
            setManager(true)
            return true
        }
        if password == self.password {
            setManager(true)
            wasAuthorizedAsManager = true
            return true
        } else {
            return false
        }
    }
    
    func logoutAsManager() {
        setManager(false)
    }
    
    func logout() {
        wasAuthorizedAsManager = false
    }
    
    private func setManager(_ value: Bool) {
        isManager = value
    }
}
