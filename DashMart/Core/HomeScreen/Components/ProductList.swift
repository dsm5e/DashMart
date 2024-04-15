//
//  ProductList.swift
//  DashMart
//
//  Created by Максим Самороковский on 15.04.2024.
//

import SwiftUI

struct ProductList: View {
    
    enum Drawing {
        static let titleFontSize: CGFloat = 12
        static let titleColor = Color(hex: "#393F42")
        static let titleFrameWidth: CGFloat = 144
        static let priceFontSize: CGFloat = 14
        static let backgroundColor = Color(hex: "#FAFAFC")
        static let imageWidth: CGFloat = 170
        static let imageHeight: CGFloat = 112
        static let cornerRadius: CGFloat = 6
        static let containerWidth: CGFloat = 170
        static let containerHeight: CGFloat = 217
        static let spacing: CGFloat = 10
    }
    
    private let products = [
        ("Monitor LG 22”inc 4K 120Fps", "$199.99", "monitor"),
        ("Aestechic Mug - white variant", "$19.99", "mug"),
        ("Playstation 4 - SSD 128 GB", "$1999.99", "ps4"),
        ("Airpods pro", "$499.99", "airpods")
    ]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Drawing.spacing) {
            ForEach(products, id: \.0) { product in
                ProductCard(title: product.0, price: product.1, imageName: product.2)
            }
        }
        .padding()
    }
}

#Preview {
    ProductList()
}
