//
//  ProductDetailView.swift
//  DashMart
//
//  Created by Максим Самороковский on 17.04.2024.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    let product: ProductEntity
    let titleDescription: String
    @ObservedObject private var storage = StorageService.shared
    private var isInWishlist: Bool {
        storage.wishlistIds.contains(product.id)
    }
    
    var body: some View {
        VStack {
            KFImage(URL(string: product.images.first ?? ""))
                .placeholder {
                    Image(.productPlaceholder)
                        .resizable()
                }
                .resizable()
                .scaledToFit()
                .frame(height: 286)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(product.title)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(hex: "#393F42"))
                    Text(product.price.formatted(.currency(code: "USD")))
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: "#393F42"))
                }
                .padding(.horizontal)
                Spacer()
                
                Button(action: {
                    Task {
                        if isInWishlist {
                            try? await storage.removeFromWishlist(product.id)
                        } else {
                            try? await storage.addToWishlist(product.id)
                        }
                    }
                }) {
                    Image(isInWishlist ? .Tab.Green.heart : .Tab.heart)
                    
                }
                .frame(width: 46, height: 46)
                .background(Color(hex: "#939393").opacity(0.1))
                .clipShape(Circle())
                .padding(.horizontal)
                
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(titleDescription)
                    .font(.system(size: 16))
                .foregroundStyle(Color(hex: "#393F42"))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(product.description)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "#393F42"))
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
}
