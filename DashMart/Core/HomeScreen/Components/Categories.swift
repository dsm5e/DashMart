//
//  Categories.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct Categories: View {
    
    @State private var showAllCategories = false
    
    private enum Drawing {
        static let titleFontSize: CGFloat = 12
        static let titleColor = Color(hex: "#939393")
        static let frameWidth: CGFloat = 40
        static let frameHeight: CGFloat = 40
        static let conteinerFrameHeight: CGFloat = 55
        static let cornerRadius: CGFloat = 8
        static let spacingCategory: CGFloat = 25
    }
    
    enum ImageName: String, CaseIterable {
        case clothes = "clothes"
        case school = "school"
        case sports = "sports"
        case electronic = "electronic"
        case all = "all C"
        
        static let popularCases: [ImageName] = [.clothes, .school, .sports, .electronic]
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(showAllCategories ? ImageName.allCases : ImageName.popularCases, id: \.self) { imageName in
                    VStack {
                        Image(imageName.rawValue)
                            .resizable()
                            .frame(width: Drawing.frameWidth, height: Drawing.frameHeight)
                        Text(imageName.rawValue.capitalized)
                            .font(.system(size: Drawing.titleFontSize))
                            .foregroundStyle(Drawing.titleColor)
                    }
                    .padding(.trailing, imageName == .all ? 0 : Drawing.spacingCategory)
                }
                
                if !showAllCategories {
                    VStack {
                        Image(ImageName.all.rawValue)
                            .resizable()
                            .frame(width: Drawing.frameWidth, height: Drawing.frameHeight)
                        Text(ImageName.all.rawValue.capitalized)
                            .font(.system(size: Drawing.titleFontSize))
                            .foregroundStyle(Drawing.titleColor)
                    }
                }
            }
            .frame(height: Drawing.conteinerFrameHeight)
            .padding()
        }
    }
}

#Preview {
    Categories()
}
