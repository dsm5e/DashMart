//
//  UIImage+Extension.swift
//  DashMart
//
//  Created by Ilya Paddubny on 22.04.2024.
//

import Foundation
import SwiftUI

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func resizedToMaxSize(maxSize: CGFloat) -> UIImage? {
            var newSize: CGSize
            
            let width = self.size.width
            let height = self.size.height
            
            if width > height {
                newSize = CGSize(width: maxSize, height: maxSize * height / width)
            } else {
                newSize = CGSize(width: maxSize * width / height, height: maxSize)
            }
            
            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
}

