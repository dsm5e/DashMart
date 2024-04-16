//
//  WishlistScreen.swift
//  DashMart
//
//  Created by Victor on 16.04.24.
//

import SwiftUI
import Kingfisher

struct WishlistScreen: View {
    
    @State private var searchInput = ""
    @ObservedObject private var storage = StorageService.shared
    @State private var products = [ProductEntity]()
    @State private var loading = false
    
    private var filteredProducts: [ProductEntity] {
        guard !searchInput.isEmpty else {
            return products
        }
        return products.filter { $0.title.contains(searchInput) }
    }
    
    var body: some View {
        ZStack {
            VStack {
                _SearchBar(searchInput: $searchInput, storage: storage)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)
                ZStack {
                    ScrollView {
                        LazyVGrid(
                            columns: [.init(.adaptive(minimum: 170, maximum: 170))],
                            spacing: 35
                        ) {
                            ForEach(filteredProducts) {
                                WishlistItem(product: $0, storage: storage)
                            }
                        }
                    }
                    if !loading {
                        Group {
                            if products.isEmpty {
                                Text("Your wishlist is empty")
                            } else if filteredProducts.isEmpty {
                                Text("None of the products match your search")
                            }
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#393F42"))
                    }
                }
                .padding(.horizontal, 20)
            }
            if loading {
                VStack {
                    ProgressView()
                }
            }
        }
        .onAppear(perform: {
            loading = true
            Task {
                await storage.getWishlist()
                let result = await withTaskGroup(of: ProductEntity?.self, returning: [ProductEntity].self) { group in
                    for id in storage.wishlistIds {
                        group.addTask {
                            let response = await NetworkService.client.sendRequest(request: ProductRequestGet(id: id))
                            return try? response.get()
                        }
                    }
                    var products = [ProductEntity]()
                    for await result in group {
                        if let result {
                            products.append(result)
                        }
                    }
                    return products.sorted(by: { storage.wishlistIds.firstIndex(of: $0.id) ?? 0 < storage.wishlistIds.firstIndex(of: $1.id) ?? 1 })
                }
                products = result
                loading = false
            }
        })
        .onChange(of: storage.wishlistIds, perform: {
            _ in
            
            products.removeAll(where: { !storage.wishlistIds.contains($0.id) })
        })
        .allowsHitTesting(!loading)
    }
}

private struct _SearchBar: View {
    
    @Binding var searchInput: String
    @ObservedObject var storage: StorageService
    
    var body: some View {
        HStack {
            HStack {
                HStack{
                    Image(.search)
                        .renderingMode(.template)
                        .foregroundColor(Color(hex: "#939393"))
                    TextField("", text: $searchInput)
                        .font(.system(size: 13))
                        .placeholder(when: searchInput.isEmpty) {
                            Text("Search here...")
                                .foregroundColor(Color(hex: "#C8C8CB"))
                                .font(.system(size: 13))
                        }
                        .padding(.leading, 14)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "F0F2F1"), lineWidth: 1)
                )
                Button(
                    action: {
                        
                    }, label: {
                        ZStack {
                            Image(.buy)
                                .renderingMode(.template)
                                .foregroundColor(Color(hex: "#393F42"))
                            if storage.basket.count > 0 {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("\(storage.basket.count)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 8, weight: .bold))
                                            .frame(width: 12, height: 12)
                                            .background(Color(hex: "#D65B5B"))
                                            .clipShape(.rect(cornerRadius: 6))
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: 28, height: 28)
                    }
                )
            }
        }
    }
}

private struct WishlistItem: View {
    
    let product: ProductEntity
    let storage: StorageService
    
    var body: some View {
        VStack {
            KFImage(product.images.first)
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
                Text(product.price.formatted(.currency(code: "USD")))
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                    .foregroundColor(Color(hex: "#393F42"))
                HStack {
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
                    Button(
                        action: {
                            storage.addToBasket(product.id)
                        },
                        label: {
                            Text("Add to card")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .padding(.vertical, 7)
                                .padding(.horizontal, 22)
                                .background(Color(hex: "#67C4A7"))
                                .clipShape(.rect(cornerRadius: 4))
                        }
                    )
                }
                .padding(.bottom, 13)
            }
        }
        .background(Color(hex: "#FAFAFC"))
        .clipShape(.rect(cornerRadius: 6))
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 4)
    }
}

#Preview {
    WishlistScreen()
}
