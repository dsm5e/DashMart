//
//  TitleFilters.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct TitleFilters: View {
    
    private enum Drawing {
        static let titleFontSize: CGFloat = 14
        static let titleColor = Color(hex: "#393F42")
        static let buttonTitle: CGFloat = 12
        static let borderColor = Color(hex: "#F0F2F1")
        static let borderWidth: CGFloat = 1
        static let highlightedBorderColor = Color(hex: "#12B76A")
        static let highlightedBorderWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 5
        static let buttonWidth: CGFloat = 78
        static let buttonHeigth: CGFloat = 27
    }
    
    let text: String
    let action: () -> Void
    
    @Binding var filtersApplied: Bool
    @Binding var isButtonActive: Bool
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: Drawing.titleFontSize))
                .foregroundStyle(Drawing.titleColor)
            Spacer()
            Button(action: {
                action()
            }, label: {
                HStack {
                    Text("Filters")
                        .font(.system(size: Drawing.buttonTitle))
                        .foregroundStyle(Drawing.titleColor)
                    Image(.filter)
                }
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                        .stroke(filtersApplied ? Drawing.highlightedBorderColor : Drawing.borderColor,
                                lineWidth: filtersApplied ? Drawing.highlightedBorderWidth : Drawing.borderWidth)
                        .frame(height: Drawing.buttonHeigth)
                )
            })
        }
    }
}

#Preview {
    TitleFilters(text: "Products", action: {}, filtersApplied: .constant(true), isButtonActive: .constant(true))
}
