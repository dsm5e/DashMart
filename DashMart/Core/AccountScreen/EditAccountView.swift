//
//  EditAccountView.swift
//  DashMart
//
//  Created by Victor on 26.04.2024.
//

import SwiftUI

struct EditAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    let onDismiss: (() -> Void)?
    
    var body: some View {
        NavigationView {
            VStack(spacing: .s16) {
                NavigationLink(
                    destination: {
                        ChangeUsernameView(onSave: {
                            dismiss()
                        }).dashNavBar(title: "")
                    },
                    label: {
                        Text("Change Username")
                            .modifier(DashRoundedTitle())
                    }
                )
                
                NavigationLink(
                    destination: {
                        ChangeAuthView(type: .email ,onSave: {
                            dismiss()
                        }).dashNavBar(title: "")
                    },
                    label: {
                        Text("Change Email")
                            .modifier(DashRoundedTitle())
                    }
                )
                
                NavigationLink(
                    destination: {
                        ChangeAuthView(type: .password, onSave: {
                            dismiss()
                        }).dashNavBar(title: "")
                    },
                    label: {
                        Text("Change Password")
                            .modifier(DashRoundedTitle())
                    }
                )
            }
        }
        .onDisappear {
            onDismiss?()
        }
    }
}

struct ChangePasswordView: View {
    
    private let authService = AuthorizeService.shared
    @State private var newPassword = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isAlertPresented = false
    @State private var message = ""
    
    let onSave: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("Enter new email:")
                .font(.system(size: 16, weight: .semibold))
            TextField("", text: $newPassword)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .padding(.s12)
                .modifier(StrokeModifier())
            Spacer()
            Button(
                action: {
                    Task {
                        guard !newPassword.isEmpty else {
                            message = "Password must not be empty"
                            isAlertPresented = true
                            return
                        }
                        let result = await authService.changePassword(password: newPassword)
                        guard result.0 else {
                            message = result.1 ?? "Failed to save new password"
                            isAlertPresented = true
                            return
                        }
                        onSave?()
                    }
                },
                label: {
                    Text("Save")
                        .modifier(DashRoundedTitle())
                }
            )
        }
        .padding(.horizontal, .s20)
        .padding(.vertical, .s16)
        .alert(
            message,
            isPresented: $isAlertPresented,
            actions: {
                Button("OK") { }
            }
        )
    }
}

struct ChangeAuthView: View {
    
    enum FieldType: String {
        case email
        case password
    }
    
    let type: FieldType
    private let authService = AuthorizeService.shared
    @State private var newValue = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isAlertPresented = false
    @State private var message = ""
    
    let onSave: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("Enter new \(type.rawValue):")
                .font(.system(size: 16, weight: .semibold))
            TextField("", text: $newValue)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .padding(.s12)
                .modifier(StrokeModifier())
            Spacer()
            Button(
                action: {
                    Task {
                        guard !newValue.isEmpty else {
                            message = "\(type.rawValue.capitalized) must not be empty"
                            isAlertPresented = true
                            return
                        }
                        let result: (Bool, String?)
                        switch type {
                        case .email:
                            result = await authService.changeEmail(email: newValue)
                        case .password:
                            result = await authService.changePassword(password: newValue)
                        }
                        guard result.0 else {
                            message = result.1 ?? "Failed to save new \(type.rawValue)"
                            isAlertPresented = true
                            return
                        }
                        onSave?()
                    }
                },
                label: {
                    Text("Save")
                        .modifier(DashRoundedTitle())
                }
            )
        }
        .padding(.horizontal, .s20)
        .padding(.vertical, .s16)
        .alert(
            message,
            isPresented: $isAlertPresented,
            actions: {
                Button("OK") { }
            }
        )
    }
}

struct ChangeUsernameView: View {
    
    @ObservedObject private var storage = StorageService.shared
    @State private var newUsername = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isAlertPresented = false
    @State private var message = ""
    
    let onSave: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("Enter new username:")
                .font(.system(size: 16, weight: .semibold))
            TextField("", text: $newUsername)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .padding(.s12)
                .modifier(StrokeModifier())
            Spacer()
            Button(
                action: {
                    Task {
                        guard !newUsername.isEmpty else {
                            message = "Username must not be empty"
                            isAlertPresented = true
                            return
                        }
                        guard await storage.setUserName(newUsername) else {
                            message = "Failed to save new username"
                            isAlertPresented = true
                            return
                        }
                        onSave?()
                    }
                },
                label: {
                    Text("Save")
                        .modifier(DashRoundedTitle())
                }
            )
        }
        .padding(.horizontal, .s20)
        .padding(.top, .s16)
        .alert(
            message,
            isPresented: $isAlertPresented,
            actions: {
                Button("OK") { }
            }
        )
    }
}

#Preview {
    EditAccountView(onDismiss: {})
}
