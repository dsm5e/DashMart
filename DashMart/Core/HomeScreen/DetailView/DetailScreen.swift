//
//  DetailScreen.swift
//  DashMart
//
//  Created by Максим Самороковский on 17.04.2024.
//

import SwiftUI

struct DetailScreen: View {
    
    @Binding var product: ProductEntity?
    private let storage = StorageService.shared
    
    var body: some View {
        if let product {
            VStack {
                VStack {
                    TitleDetail()
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
                        storage.addToBasket(product.id)
                    }
                    
                    ButtonsDetail(title: "Buy Now", type: .buy) {
                        // action
                    }
                }
            }
        } else {
            VStack { }
        }
    }
}
