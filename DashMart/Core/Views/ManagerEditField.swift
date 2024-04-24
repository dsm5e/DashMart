//
//  ManagerEditField.swift
//  DashMart
//
//  Created by Victor on 23.04.2024.
//

import SwiftUI

struct ManagerEditField<Content: View>: View {
    
    let title: String
    let padding: CGFloat
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: 75, alignment: .leading)
                .padding(.trailing, .s16)
            
            content()
                .padding(padding)
                .modifier(StrokeModifier())
        }
        .font(.system(size: 13, weight: .semibold))
    }
}

struct StrokeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: .s4)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(hex: "#F0F2F1"))
            )
    }
}
