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
    @State private var selectedImage: Image?


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
                            if let selectedImage = selectedImage {
                                selectedImage
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(.rect(cornerRadius: 50))
                            } else {
                                Image(.productPlaceholder)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(.rect(cornerRadius: 50))
                            }
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
                                Task {
                                    @MainActor in
                                    
                                    if await AuthorizeService.shared.logout() {
                                        managerService.logout()
                                        router.openAuth()
                                    }
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
                    ChangeAvatarMenu(selectedImage: $selectedImage)
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
        }
        .task {
            name = (try? await StorageService.shared.getUserName()) ?? "UserName"
            email = (try? await StorageService.shared.getUserEmail()) ?? "user@mail.com"
        }
    }
}

private struct ChangeAvatarMenu: View {
    @State private var isPhotoPickerPresnted = false
    @Binding var selectedImage: Image?
    
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
                    SeparatorView()
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
                                isPhotoPickerPresnted = true
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
        .sheet(isPresented: $isPhotoPickerPresnted) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$selectedImage)
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

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: Image?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: image)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

#Preview {
    AccountView(router: RouterService())
}
