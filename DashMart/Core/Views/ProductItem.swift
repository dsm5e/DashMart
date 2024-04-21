//
//  ProductItem.swift
//  DashMart
//
//  Created by Victor on 21.04.2024.
//

import SwiftUI
import Kingfisher

struct ProductItem: View {
    
    @ObservedObject private var location = LocationService.shared
    let product: ProductEntity
    let storage: StorageService
    let showWishlistButton: Bool
    
    var body: some View {
        VStack {
            KFImage(URL(string: product.images.first ?? ""))
                .placeholder {
                    Image(.productPlaceholder)
                        .resizable()
                        .scaledToFill()
                }
                .resizable()
                .scaledToFill()
                .frame(width: 170, height: 112)
                .clipped()
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .foregroundColor(Color(hex: "#393F42"))
                    .padding(.vertical, 2)
                Text(location.exchange(product.price).formatted(
                    .currency(code: location.currencyCode)
                ))
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                    .foregroundColor(Color(hex: "#393F42"))
                HStack {
                    if showWishlistButton {
                        Button(
                            action: {
                                Task {
                                    try? await storage.removeFromWishlist(product.id)
                                }
                            },
                            label: {
                                Image(.Tab.Green.heart)
                            }
                        )
                    }
                    Button(
                        action: {
                            storage.addToCart(product.id)
                        },
                        label: {
                            Text("Add to card")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .padding(7)
                                .background(Color(hex: "#67C4A7"))
                                .clipShape(.rect(cornerRadius: 4))
                        }
                    )
                }
            }
            .padding(.horizontal, 13)
            .padding(.bottom, 13)
        }
        .background(Color(hex: "#FAFAFC"))
        .clipShape(.rect(cornerRadius: 6))
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 4)
    }
}
