//
//  AccountScreen.swift
//  DashMart
//
//  Created by Victor on 18.04.2024.
//

import SwiftUI

struct AccountView: View {
    
    @State var router: RouterService
    @State private var name = ""
    @State private var email = ""
    @State private var managerPassword = ""
    @State private var isAvatarMenuPresented = false
    @State private var isTermsPresented = false
    @State private var isTypeSelectionPresented = false
    @State private var isManagerPasswordPresented = false
    @State private var isManagerErrorPresented = false
    @ObservedObject private var managerService = ManagerService.shared
    @State private var avatarImage: UIImage?
    @State private var loading = false
    @State private var isEditProfileDialogPresented = false
    
    @State private var showAlert = false
    
    private var attributedEmail: AttributedString {
        var string = AttributedString(email)
        string.font = .systemFont(ofSize: 14)
        string.underlineStyle = .single
        return string
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if loading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                ZStack {
                    VStack {
                        avatarSection
                        Spacer()
                        buttonSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 14)
                    .padding(.bottom, 22)
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .zIndex(0)
                    
                    if isAvatarMenuPresented {
                        ChangeAvatarMenu(isAvatarMenuPresented: $isAvatarMenuPresented, avatarImage: $avatarImage)
                            .onTapGesture {
                                isAvatarMenuPresented = false
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                            .ignoresSafeArea(.all)
                            .zIndex(1)
                    }
                    
                }
            }
            .sheet(isPresented: $isTermsPresented) {
                TermsView()
            }
            .confirmationDialog(
                "Account Type",
                isPresented: $isTypeSelectionPresented,
                actions: {
                    Button("User") {
                        managerService.logoutAsManager()
                    }
                    Button("Manager") {
                        if managerService.needPassword {
                            isManagerPasswordPresented = true
                        } else {
                            managerService.enterAsManager(nil)
                        }
                    }
                }
            )
            .alert(
                "Enter manager password",
                isPresented: $isManagerPasswordPresented
            ) {
                TextField("Enter password", text: $managerPassword)
                Button("OK") {
                    isManagerErrorPresented = !managerService.enterAsManager(managerPassword)
                    managerPassword = ""
                }
            }
            .alert(
                "Error",
                isPresented: $isManagerErrorPresented,
                actions: { Button("OK") { } },
                message: {
                    Text("Invalid manager password")
                }
            )
            .bottomSheet(
                isPresented: $isEditProfileDialogPresented,
                detents: [.medium()],
                contentView: {
                    EditAccountView {
                        Task {
                            name = (try? await StorageService.shared.getUserName(force: true)) ?? "UserName"
                            email = (try? await StorageService.shared.getUserEmail(force: true)) ?? "user@mail.com"
                        }
                    }
                }
            )
        }
        .task {
            name = (try? await StorageService.shared.getUserName()) ?? "UserName"
            email = (try? await StorageService.shared.getUserEmail()) ?? "user@mail.com"
            do {
                avatarImage = try await StorageService.shared.getAvatarImage()
            } catch {
                avatarImage = nil
                
            }
        }
    }
    
    var avatarSection: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: avatarImage ?? .productPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
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
                if managerService.isManager {
                    Text("Manager")
                        .foregroundColor(.white)
                        .background(Color(hex: "#67C4A7"))
                        .font(.system(size: 16, weight: .semibold))
                        .clipShape(.rect(cornerRadius: 3))
                }
                Text(name)
                    .foregroundColor(Color(hex: "#333647"))
                    .font(.system(size: 16, weight: .semibold))
                Text(attributedEmail)
                    .foregroundStyle(Color(hex: "#7C82A1"))
            }
            .padding(.leading, 40)
            .onTapGesture {
                isEditProfileDialogPresented = true
            }
            Spacer()
        }
    }
    
    var buttonSection: some View {
        VStack(spacing: 22) {
            RoundedButton(
                title: "Type of account",
                rightIcon: Image(.angleRight),
                handler: {
                    isTypeSelectionPresented = true
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
                    showAlert = true
                },
                titleColor: Color(hex: "#666C8E")
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(""),
                    message: Text("Are you sure you want to sign out?").bold(),
                    primaryButton: .default(Text("Yes")) {
                        loading = true
                        Task {
                            @MainActor in
                            if await AuthorizeService.shared.logout() {
                                managerService.logout()
                                router.openAuth()
                            }
                            loading = false
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
}

private struct ChangeAvatarMenu: View {
    @State private var isPhotoPickerPresnted = false
    @State private var isCameraActive = false
    @State private var capturedImage: UIImage?

    @Binding var isAvatarMenuPresented: Bool
    @Binding var avatarImage: UIImage?
    
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
                        .padding(.top, .s24)
                        .padding(.bottom, .s16)
                    SeparatorView()
                    VStack(spacing: .s20) {
                        AvatarMenuButton(
                            title: "Take a Selfie",
                            icon: Image(systemName: "camera"),
                            handler: {
                                self.isCameraActive = true
                            },
                            color: .black
                        )
                        
                        AvatarMenuButton(
                            title: "Choose from your file",
                            icon: Image(systemName: "folder"),
                            handler: {
                                isPhotoPickerPresnted = true
                            },
                            color: .black
                        )
                        
                        AvatarMenuButton(
                            title: "Delete Photo",
                            icon: Image(systemName: "trash"),
                            handler: {
                                Task {
                                    isAvatarMenuPresented = false
                                    avatarImage = nil
                                    try? await StorageService.shared.deleteAvatarImage()
                                }
                            },
                            color: Color(hex: "#E53935")
                        )
                    }
                    .padding(.horizontal, .s16)
                    .padding(.vertical, .s20)
                }
                .frame(width: 300)
                .background(Color(hex: "#FEFEFE"))
                .clipShape(.rect(cornerRadius: .s12))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isPhotoPickerPresnted) {
            ImagePicker(sourceType: .photoLibrary,
                        avatarImage: self.$avatarImage,
                        isAvatarMenuPresented: $isAvatarMenuPresented)
            .ignoresSafeArea(.all)
        }
        .sheet(isPresented: $isCameraActive) {
            ImagePicker(sourceType: .camera,
                        avatarImage: self.$avatarImage,
                        isAvatarMenuPresented: $isAvatarMenuPresented)
            .ignoresSafeArea(.all)
        }
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
                    HStack(spacing: .s16) {
                        icon
                            .frame(width: 18, height: 18)
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundColor(color)
                    .padding(.horizontal, .s16)
                }
                .frame(height: 60)
                .background(Color(hex: "#F5F5F5"))
                .clipShape(.rect(cornerRadius: .s8))
            }
        )
    }
}

#Preview {
    AccountView(router: RouterService())
}
