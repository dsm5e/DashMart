//
//  TitleFilters.swift
//  DashMart
//
//  Created by Максим Самороковский on 15.04.2024.
//

import SwiftUI

struct TitleFilters: View {
    
    private enum Drawing {
        static let titleFontSize: CGFloat = 14
        static let titleColor = Color(hex: "#393F42")
        static let buttonTitle: CGFloat = 12
        static let borderColor = Color(hex: "#F0F2F1")
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 5
        static let buttonWidth: CGFloat = 78
        static let buttonHeigth: CGFloat = 27
    }
    
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: Drawing.titleFontSize))
                .foregroundStyle(Drawing.titleColor)
            Spacer()
            Spacer()
            Button(action: {}, label: {
                HStack {
                    Text("Filters")
                        .font(.system(size: Drawing.buttonTitle))
                        .foregroundStyle(Drawing.titleColor)
                    Image(.filter)
                }
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                        .stroke(Drawing.borderColor, lineWidth: Drawing.borderWidth)
                        .frame(height: Drawing.buttonHeigth)
                )
            })
            Spacer()
        }
    }
}

#Preview {
    TitleFilters(text: "Products")
}
