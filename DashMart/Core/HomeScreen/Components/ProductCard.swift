//
//  ProductCard.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct ProductCard: View {
    let title: String
    let price: String
    let imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: ProductList.Drawing.cornerRadius)
                .fill(ProductList.Drawing.backgroundColor)
                .frame(width: ProductList.Drawing.containerWidth, height: ProductList.Drawing.containerHeight)
            
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: ProductList.Drawing.imageWidth, height: ProductList.Drawing.imageHeight)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: ProductList.Drawing.titleFontSize))
                        .foregroundStyle(ProductList.Drawing.titleColor)
                        .frame(width: ProductList.Drawing.titleFrameWidth)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(price)
                        .font(.system(size: ProductList.Drawing.priceFontSize))
                        .foregroundStyle(ProductList.Drawing.titleColor)
                }
                .padding(6)
                CustomButton(title: "Add to cart") {
                    // action
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ProductCard(title: "Monitor LG 22”inc 4K 120Fps", price: "$199.99", imageName: "monitor")
}
