//
//  HomeScreen.swift
//  DashMart
//
//  Created by dsm 5e on 14.04.2024.
//

import SwiftUI
import Kingfisher

struct HomeScreen: View {
    @State private var searchInput: String = ""
    @State private var isShowingSearchResults = false
    @State private var isShowingDetails = false
    @ObservedObject private var storage = StorageService.shared
    @State private var products = [ProductEntity]()
    @State private var filteredProducts = [ProductEntity]()
    @State private var categories = [CategoryEntity]()
    @State private var selectedCategory: Int? = nil
    @State private var selectedProduct: ProductEntity? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            NavBarMenu(storage: storage)
                .padding(.horizontal, 20)
            
            Button(
                action: {
                    isShowingSearchResults = true
                },
                label: {
                    SearchTextField(searchInput: $searchInput)
                        .disabled(true)
                }
            )
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [.init(spacing: 16)]) {
                    ForEach(categories) {
                        category in
                        
                        Button(
                            action: {
                                selectedCategory = category.id == -1 ? nil : category.id
                            },
                            label: {
                                CategoryView(category: category)
                                    .frame(width: 67)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 61)
            }
            
            TitleFilters(text: "Products")
                .padding(.horizontal, 20)
            
            ScrollView {
                LazyVGrid(
                    columns: [.init(),.init()],
                    spacing: 8
                ) {
                    ForEach(filteredProducts) {
                        product in
                        
                        Button(
                            action: {
                                selectedProduct = product
                                isShowingDetails = true
                            },
                            label: {
                                ProductItem(
                                    product: product,
                                    storage: storage,
                                    showWishlistButton: false
                                )
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top)
        .task {
            await getProducts()
        }
        .onChange(of: selectedCategory) {
            value in
            
            guard let value else {
                filteredProducts = products
                return
            }
            filteredProducts = products.filter { $0.category.id == value }
        }
        .fullScreenCover(isPresented: $isShowingSearchResults) {
            SearchResultScreen(
                searchInput: $searchInput,
                products: $products
            )
        }
        .fullScreenCover(isPresented: $isShowingDetails) {
            DetailScreen(product: $selectedProduct)
        }
    }
}



extension HomeScreen {
    func getProducts() async {
        switch await NetworkService.client.sendRequest(request: ProductsRequest(categoryId: selectedCategory)) {
        case .success(let result):
            products = result
            filteredProducts = products
            
            var categoriesFrequency = [CategoryEntity: Int]()
            products.forEach {
                categoriesFrequency[$0.category] = categoriesFrequency[$0.category, default: 0] + 1
            }
            if categories.isEmpty {
                categories = categoriesFrequency.sorted { $0.value > $1.value }.map { $0.key }.suffix(4) + [.all]
            }
        case .failure(let error):
            print(error)
        }
    }
}

extension CategoryEntity {
    static let all: CategoryEntity = .init(id: -1, name: "All", image: "")
}

#Preview {
    HomeScreen()
}
