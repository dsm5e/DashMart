//
//  RoundedButton.swift
//  DashMart
//
//  Created by Victor on 16.04.2024.
//

import SwiftUI

struct RoundedButton: View {
    
    let title: String
    let rightIcon: Image
    let handler: (() -> Void)?
    let titleColor: Color
    
    init(
        title: String,
        rightIcon: Image,
        handler: (() -> Void)?,
        titleColor: Color = Color(hex: "#666C8E")
    ) {
        self.title = title
        self.rightIcon = rightIcon
        self.handler = handler
        self.titleColor = titleColor
    }
    
    var body: some View {
        Button(
            action: {
                handler?()
            },
            label: {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(titleColor)
                    Spacer()
                    rightIcon
                        .renderingMode(.template)
                        .foregroundColor(Color(hex: "#666C8E"))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(hex: "#F3F4F6"))
                .clipShape(.rect(cornerRadius: 12))
            }
        )
    }
}

#Preview {
    RoundedButton(
        title: "Type of account",
        rightIcon: .init(systemName: "chevron.right"),
        handler: {
            print("tap")
        }
    )
}
