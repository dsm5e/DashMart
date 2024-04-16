//
//  SearchBar.swift
//  DashMart
//
//  Created by Максим Самороковский on 15.04.2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    
    private enum Drawing {
        static let imagePadding: CGFloat = 10
        static let imageName: String = "search"
        static let titleFontSize: CGFloat = 13
        static let borderColor = Color(hex: "#F0F2F1")
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let frameHeight: CGFloat = 40
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                .stroke(Drawing.borderColor, lineWidth: Drawing.borderWidth)
            
            HStack {
                Image(.search)
                    .padding(Drawing.imagePadding)
                
                TextField("Search here ...", text: $text, onCommit: onCommit)
                    .font(.system(size: Drawing.titleFontSize))
            }
            .padding(.horizontal, Drawing.imagePadding)
        }
        .frame(height: Drawing.frameHeight)
    }
}

#Preview {
    SearchBar(text: .constant(""), onCommit: {})
}
