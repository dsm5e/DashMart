//
//  CustomIconButton.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

import SwiftUI

struct CustomIconButton: View {
    let imageName: String
    let badgeCount: Int
    let action: () -> Void
    
    private enum Drawing {
        static let buttonSize: CGFloat = 28
        static let badgeSize: CGFloat = 16
        static let badgeColor = Color(hex: "#D65B5B")
        static let badgeTitleColor = Color(hex: "#FFFFFF")
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(imageName)
                    .frame(width: Drawing.buttonSize, height: Drawing.buttonSize)
                
                if badgeCount > 0 {
                    Text("\(badgeCount)")
                        .foregroundColor(Drawing.badgeTitleColor)
                        .font(Font.system(size: 10, weight: .bold))
                        .padding(5)
                        .background(Drawing.badgeColor)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
        }
    }
}

#Preview {
    CustomIconButton(imageName: "buy", badgeCount: 2) {
        // action
    }
}
