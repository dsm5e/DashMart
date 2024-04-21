//
//  SearchTextField.swift
//  DashMart
//
//  Created by Victor on 21.04.2024.
//

import SwiftUI

struct SearchTextField: View {
    
    @Binding var searchInput: String
    
    var body: some View {
        HStack{
            Image(.search)
                .renderingMode(.template)
                .foregroundColor(Color(hex: "#939393"))
            TextField("", text: $searchInput)
                .font(.system(size: 13))
                .placeholder(when: searchInput.isEmpty) {
                    Text("Search here...")
                        .foregroundColor(Color(hex: "#C8C8CB"))
                        .font(.system(size: 13))
                }
                .padding(.leading, 14)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "F0F2F1"), lineWidth: 1)
        )
    }
}
