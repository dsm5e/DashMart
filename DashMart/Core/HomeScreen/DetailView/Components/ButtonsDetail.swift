//
//  ButtonsDetail.swift
//  DashMart
//
//  Created by Максим Самороковский on 17.04.2024.
//

import SwiftUI

struct ButtonsDetail: View {
    
    enum ButtonType {
        case add
        case buy
    }
    
    private struct ButtonStyle {
        let titleColor: Color
        let buttonColor: Color
        let borderColor: Color
        let borderWidth: CGFloat
    }
    
    private static let addStyle = ButtonStyle(titleColor: Color(hex: "#FFFFFF"), buttonColor: Color(hex: "#67C4A7"), borderColor: Color.clear, borderWidth: 0)
    private static let buyStyle = ButtonStyle(titleColor: Color(hex: "#393F42"), buttonColor: Color(hex: "#F0F2F1"), borderColor: Color(hex: "#D9D9D9"), borderWidth: 1)
    
    let title: String
    let type: ButtonType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(style.titleColor)
                .frame(width: 167, height: 45)
                .background(style.buttonColor)
                .border(style.borderColor, width: style.borderWidth)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
    
    private var style: ButtonStyle {
        switch type {
        case .add:
            return ButtonsDetail.addStyle
        case .buy:
            return ButtonsDetail.buyStyle
        }
    }
}

#Preview {
    HStack {
        ButtonsDetail(title: "Add to Cart", type: .add) {}
        ButtonsDetail(title: "Buy Now", type: .buy) {}
    }
}
