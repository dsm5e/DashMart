//
//  CustomButton.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct CustomButton: View {
    
    private enum Drawing {
        static let buttonColor = Color(hex: "#67C4A7")
        static let buttonTitleColor = Color(hex: "#FFFFFF")
        static let buttonTitleFontSize: CGFloat = 12
        static let cornerRadius: CGFloat = 4
        static let buttonWidth: CGFloat = 144
        static let buttonHeigth: CGFloat = 31
    }
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Drawing.buttonTitleFontSize))
                .foregroundStyle(Drawing.buttonTitleColor)
                .frame(width: Drawing.buttonWidth, height: Drawing.buttonHeigth)
                .background(Drawing.buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
        }
    }
}

#Preview {
    CustomButton(title: "Add to cart", action: {})
}
