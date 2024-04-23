//
//  ImagePicker.swift
//  DashMart
//
//  Created by Ilya Paddubny on 23.04.2024.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType
    @Binding var avatarImage: UIImage?
    @Binding var isAvatarMenuPresented: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        if sourceType == .camera {
            imagePicker.cameraDevice = .front
        }


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

            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.isAvatarMenuPresented = false
                guard let resizedImage = selectedImage.resizedToMaxSize(maxSize: 200.0) else {
                    return
                }
                parent.avatarImage = resizedImage
                Task {
                    try? await StorageService.shared.setAvatarImage(resizedImage)
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
