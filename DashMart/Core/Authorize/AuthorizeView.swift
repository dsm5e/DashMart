//
//  LoginView.swift
//  NewsToDay
//
//  Created by Victor on 16.04.2024.
//

import SwiftUI

struct AuthorizeView: View {
    
    @ObservedObject var store: AuthorizeStore
    
    @State private var email = ""
    @State private var password = ""
    @State private var repeatedPassword = ""
    @State private var userName = ""
    @State private var isAlertPresenting = false
    @State private var alertMessage = ""
    
    init(router: RouterService) {
        store = AuthorizeStore(router: router)
    }
    
    var body: some View {
        
        let shouldDisplayError = Binding<Bool>(
            get: {
                store.state.error != nil
            },
            set: {
                _ in
                
                store.dispatch(action: .errorWatched)
            }
        )
        
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        VStack {
                            if store.state.loginType == .signUp {
                                LoginTextField(text: $userName, placeholder: "Username", leftImage: .init(.iconProfile), secured: false)
                            }
                            LoginTextField(text: $email, placeholder: "Email Address".localized(), leftImage: .init(.iconEnvelope), secured: false)
                            LoginTextField(text: $password, placeholder: "Password".localized(), leftImage: .init(.iconPadlock), secured: true)
                            if store.state.loginType == .signUp {
                                LoginTextField(text: $repeatedPassword, placeholder: "Repeat Password".localized(), leftImage: .init(.iconPadlock), secured: true)
                            }
                        }
                        .padding(.init(top: .zero, leading: .zero, bottom: 64, trailing: .zero))
                        Button(
                            action: {
                                switch store.state.loginType {
                                case .signIn:
                                    store.dispatch(action: .signIn(.init(email: email, password: password)))
                                case .signUp:
                                    store.dispatch(
                                        action: .signUp(
                                            .init(
                                                username: userName,
                                                email: email,
                                                password: password,
                                                repeatedPassword: repeatedPassword
                                            )
                                        )
                                    )
                                }
                            },
                            label: {
                                Text(store.state.loginType == .signIn ? "Sign In".localized() : "Sign Up".localized())
                                    .frame(maxWidth: .infinity, minHeight: 56)
                                    .foregroundColor(.white)
                                    .background(Color.purplePrimary)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                        )
                        
                    }
                }
                Spacer()
                Button(
                    action: {
                        store.dispatch(action: .toogle)
                    },
                    label: {
                        HStack {
                            Text("Already have an account?".localized())
                                .foregroundColor(Color.blackLighter)
                            Text(store.state.loginType == .signIn ? "Sign Up".localized() : "Sign In".localized())
                                .foregroundStyle(Color.blackPrimary)
                        }
                        .font(.interMedium16)
                    }
                )
            }
            .padding(20)
            .allowsHitTesting(!store.state.loader)
            
            if store.state.loader {
                VStack {
                    ProgressView()
                }
            }
        }
        .onTapGesture(perform: {
            endTextEditing()
        })
        .alert(
            "Error".localized(),
            isPresented: shouldDisplayError,
            actions: {
                Button("OK") { }
            },
            message: {
                Text(store.state.error ?? "")
            }
        )
    }
}

struct LoginTextField: View {
    
    enum FocusedField: Hashable {
        case secured
        case regular
    }
    
    @Binding var text: String
    let placeholder: String
    let secured: Bool
    
    @State private var isSecured = true
    @State private var isEditing = false
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        HStack(spacing: 24) {
            if secured, isSecured {
                SecureField(
                    "",
                    text: $text
                )
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.gray)
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .focused($focusedField, equals: .secured)
            } else {
                TextField(
                    "",
                    text: $text
                )
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.gray)
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .focused($focusedField, equals: .regular)
            }
            if secured, !text.isEmpty {
                Button(action: {
                    isSecured.toggle()
                    focusedField = isSecured ? .secured : .regular
                }) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .accentColor(.gray)
                }
            }
        }
        .padding(.init(top: .zero, leading: 16, bottom: .zero, trailing: 16))
        .frame(height: 56)
        .background(Color.g)
        .clipShape(.rect(cornerRadius: 12))
    }
}

private extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

#Preview {
    AuthorizeView(router: RouterService())
}
