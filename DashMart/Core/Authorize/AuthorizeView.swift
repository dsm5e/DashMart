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
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            if store.state.loginType == .signUp {
                                Text("Complete your account")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 32)
                            }
                            VStack {
                                if store.state.loginType == .signUp {
                                    LoginTextField(text: $userName, title: "Name", placeholder: "Enter your name", secured: false)
                                }
                                LoginTextField(text: $email, title: "E-mail", placeholder: "Enter your email address", secured: false)
                                LoginTextField(text: $password, title: "Password", placeholder: "Enter your password", secured: true)
                                if store.state.loginType == .signUp {
                                    LoginTextField(text: $repeatedPassword, title: "Confirm Password", placeholder: "Repeat Password", secured: true)
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
                                    Text(store.state.loginType == .signIn ? "Sign In" : "Sign Up")
                                        .frame(maxWidth: .infinity, minHeight: 56)
                                        .foregroundColor(.white)
                                        .background(Color(hex: "#67C4A7"))
                                        .clipShape(.rect(cornerRadius: 24))
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
                                Text(store.state.loginType == .signIn ? "Don't have an account yet?" : "Already have an account?")
                                    .foregroundColor(Color(hex: "#66707A"))
                                Text(store.state.loginType == .signIn ? "Sign Up" : "Sign In")
                                    .foregroundStyle(Color(hex: "#67C4A7"))
                            }
                            .font(.system(size: 16, weight: .semibold))
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
            .navigationTitle(store.state.loginType == .signIn ? "Sign Up" : "Sign In")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onTapGesture(perform: {
            endTextEditing()
        })
        .alert(
            "Error",
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
    let title: String?
    let placeholder: String
    let secured: Bool
    
    @State private var isSecured = true
    @State private var isEditing = false
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            if let title {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#78828A"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
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
            .frame(height: 52)
            .background(Color(hex: "#F6F8FE"))
            .clipShape(.rect(cornerRadius: 24))
        }
    }
}

#Preview {
    AuthorizeView(router: RouterService())
}
