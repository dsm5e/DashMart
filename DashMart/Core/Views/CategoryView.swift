//
//  CategoryView.swift
//  DashMart
//
//  Created by Victor on 21.04.2024.
//

import SwiftUI
import Kingfisher

struct CategoryView: View {
    
    let category: CategoryEntity
    
    var body: some View {
        VStack {
            Group {
                if category.id == -1 {
                    Image(.categoryAll)
                        .resizable()
                } else {
                    KFImage(URL(string: category.image))
                        .resizable()
                }
            }
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 8))
            Text(category.name)
                .lineLimit(1)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#939393"))
        }
    }
}