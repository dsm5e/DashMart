//
//  DetailScreen.swift
//  DashMart
//
//  Created by Максим Самороковский on 17.04.2024.
//

import SwiftUI

struct DetailScreen: View {
    
    @Binding var product: ProductEntity?
    @State private var isCartPresented = false
    private let storage = StorageService.shared
    
    var body: some View {
        if let product {
            VStack {
                VStack {
                    TitleDetail(cartButtonAction: {
                        isCartPresented = true
                    })
                        .padding()
                    ProductDetailView(
                        product: product,
                        titleDescription: "Description of product"
                    )
                }
                Spacer()
                
                SeparatorView()
                    .padding(.bottom)
                HStack {
                    ButtonsDetail(title: "Add to Cart", type: .add) {
                        storage.addToCart(product.id)
                    }
                    
                    ButtonsDetail(title: "Buy Now", type: .buy) {
                        storage.addToCart(product.id)
                        storage.setBuyNowId(product.id)
                        isCartPresented = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isCartPresented) {
                CartScreen()
            }
        } else {
            VStack { }
        }
    }
}
