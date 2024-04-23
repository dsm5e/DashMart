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
                HStack(spacing: .s16) {
                    Button(
                        action: {
                            storage.addToCart(product.id)
                        }, label: {
                            Text("Add to Card")
                                .modifier(DashRoundedTitle())
                        }
                    )
                    Button(
                        action: {
                            storage.addToCart(product.id)
                        	storage.setBuyNowId(product.id)
                        	isCartPresented = true
                        }, label: {
                            Text("Buy now")
                                .modifier(DashRoundedTitle(style: .gray))
                        }
                    )
                }
                .padding(.horizontal, .s20)
            }
            .fullScreenCover(isPresented: $isCartPresented) {
                CartScreen()
            }
        } else {
            VStack { }
        }
    }
}
