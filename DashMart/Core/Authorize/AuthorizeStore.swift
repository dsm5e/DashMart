//
//  AuthorizeStore.swift
//  NewsToDay
//
//  Created by Victor on 16.04.2024.
//

import Foundation
import Combine

final class AuthorizeStore: ObservableObject {
    @Published private(set) var state: AuthorizeModel = .init(
        loginType: .signIn,
        error: nil
    )
    private let reducer = AuthorizeReducer()
    private let router: RouterService
    
    init(router: RouterService) {
        self.router = router
    }
    
    func dispatch(action: Action) {
        switch action {
        case .toogle:
            state = .init(loginType: state.loginType == .signIn ? .signUp : .signIn)
        case .errorWatched:
            state = .init(loginType: state.loginType)
        case .signIn(let model):
            state = .init(loginType: .signIn, loader: true)
            Task {
                @MainActor in
                do {
                    try await reducer.authorize(email: model.email, password: model.password)
                    router.openApp()
                } catch {
                    self.state = .init(loginType: .signIn, error: error.localizedDescription)
                }
            }
        case .signUp(let model):
            guard model.password == model.repeatedPassword else {
                state = .init(loginType: .signUp, error: "Password mismatch")
                return
            }
            state = .init(loginType: .signUp, loader: true)
            Task {
                @MainActor in
                
                do {
                    try await reducer.register(username: model.username, email: model.email, password: model.password)
                    router.openApp()
                } catch {
                    self.state = .init(loginType: .signUp, error: error.localizedDescription)
                }
            }
        }
    }
}

extension AuthorizeStore {
    enum Action {
        case signUp(SignUpModel)
        case signIn(SignInModel)
        case toogle
        case errorWatched
        
        struct SignUpModel {
            let username: String
            let email: String
            let password: String
            let repeatedPassword: String
        }
        
        struct SignInModel {
            let email: String
            let password: String
        }
    }
    
    struct AuthorizeModel {
        enum LoginType {
            case signIn
            case signUp
        }
        
        let loginType: LoginType
        let loader: Bool
        let error: String?
        
        init(
            loginType: LoginType,
            loader: Bool = false,
            error: String? = nil
        ) {
            self.loginType = loginType
            self.loader = loader
            self.error = error
        }
    }
}
