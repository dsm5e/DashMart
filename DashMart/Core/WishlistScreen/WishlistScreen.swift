//
//  WishlistScreen.swift
//  DashMart
//
//  Created by Victor on 16.04.24.
//

import SwiftUI

struct WishlistScreen: View {
    
    @State private var searchInput = ""
    @ObservedObject private var storage = StorageService.shared
    @State private var products = [ProductEntity]()
    @State private var loading = false
    @State private var isDetailsShowing = false
    @State private var selectedProduct: ProductEntity? = nil
    
    private var filteredProducts: [ProductEntity] {
        guard !searchInput.isEmpty else {
            return products
        }
        return products.filter { $0.title.contains(searchInput) }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    SearchTextField(searchInput: $searchInput)
                    CardButton(storage: storage)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 14)
                ZStack {
                    ScrollView {
                        LazyVGrid(
                            columns: [.init(.adaptive(minimum: 170, maximum: 170))],
                            spacing: 35
                        ) {
                            ForEach(filteredProducts) {
                                product in
                                
                                Button(
                                    action: {
                                        selectedProduct = product
                                        isDetailsShowing = true
                                    },
                                    label: {
                                        ProductItem(
                                            product: product,
                                            storage: storage,
                                            showWishlistButton: true
                                        )
                                    }
                                )
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
        .fullScreenCover(isPresented: $isDetailsShowing) {
            DetailScreen(product: $selectedProduct)
        }
        .allowsHitTesting(!loading)
    }
}

#Preview {
    WishlistScreen()
}
