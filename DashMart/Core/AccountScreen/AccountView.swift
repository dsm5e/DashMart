//
//  AccountScreen.swift
//  DashMart
//
//  Created by Victor on 18.04.2024.
//

import SwiftUI

struct AccountView: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var isAvatarMenuPresented = false
    @State private var isTermsPresented = false
    private var attributedEmail: AttributedString {
        var string = AttributedString(email)
        string.font = .systemFont(ofSize: 14)
        string.underlineStyle = .single
        return string
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.productPlaceholder)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(.rect(cornerRadius: 50))
                            Button(
                                action: {
                                    withAnimation(.smooth) {
                                        isAvatarMenuPresented = true
                                    }
                                },
                                label: {
                                    Image(.edit)
                                        .offset(x: 5)
                                }
                            )
                        }
                        
                        VStack(alignment: .leading) {
                            Text(name)
                                .foregroundColor(Color(hex: "#333647"))
                                .font(.system(size: 16, weight: .semibold))
                            Text(attributedEmail)
                                .foregroundStyle(Color(hex: "#7C82A1"))
                        }
                        .padding(.leading, 40)
                        Spacer()
                    }
                    Spacer()
                    VStack(spacing: 22) {
                        RoundedButton(
                            title: "Type of account",
                            rightIcon: Image(.angleRight),
                            handler: {
                                
                            },
                            titleColor: Color(hex: "#666C8E")
                        )
                        RoundedButton(
                            title: "Terms & Conditions",
                            rightIcon: Image(.angleRight),
                            handler: {
                                isTermsPresented = true
                            },
                            titleColor: Color(hex: "#666C8E")
                        )
                        RoundedButton(
                            title: "Sign Out",
                            rightIcon: Image(.signout),
                            handler: {
                                Task {
                                    await AuthorizeService.shared.logout()
                                }
                            },
                            titleColor: Color(hex: "#666C8E")
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 14)
                .padding(.bottom, 22)
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                
                if isAvatarMenuPresented {
                    ChangeAvatarMenu()
                        .onTapGesture {
                            withAnimation(.smooth) {
                                isAvatarMenuPresented = false
                            }
                        }
                        .ignoresSafeArea(.all)
                }
            }
            .sheet(isPresented: $isTermsPresented) {
                TermsView()
            }
        }
        .task {
            name = (try? await StorageService.shared.getUserName()) ?? "UserName"
            email = (try? await StorageService.shared.getUserEmail()) ?? "user@mail.com"
        }
    }
}

private struct ChangeAvatarMenu: View {
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .opacity(0.9)
            VStack {
                Spacer()
                VStack {
                    Text("Change your picture")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                    Color(hex: "#E8E8E8")
                        .frame(height: 1)
                    VStack(spacing: 20) {
                        AvatarMenuButton(
                            title: "Take a photo",
                            icon: Image(systemName: "camera"),
                            handler: {
                                print("camera")
                            },
                            color: .black
                        )
                        
                        AvatarMenuButton(
                            title: "Choose from your file",
                            icon: Image(systemName: "folder"),
                            handler: {
                                print("choose")
                            },
                            color: .black
                        )
                        
                        AvatarMenuButton(
                            title: "Delete Photo",
                            icon: Image(systemName: "trash"),
                            handler: {
                                print("delete")
                            },
                            color: Color(hex: "#E53935")
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
                .frame(width: 300)
                .background(Color(hex: "#FEFEFE"))
                .clipShape(.rect(cornerRadius: 12))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct AvatarMenuButton: View {
    
    let title: String
    let icon: Image
    let handler: (() -> Void)?
    let color: Color
    
    var body: some View {
        Button(
            action: {
                handler?()
            },
            label: {
                VStack(alignment: .leading) {
                    HStack(spacing: 16) {
                        icon
                            .frame(width: 18, height: 18)
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundColor(color)
                    .padding(.horizontal, 16)
                }
                .frame(height: 60)
                .background(Color(hex: "#F5F5F5"))
                .clipShape(.rect(cornerRadius: 8))
            }
        )
    }
}

#Preview {
    AccountView()
}
