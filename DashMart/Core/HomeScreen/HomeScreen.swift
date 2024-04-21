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
    @State private var isShowingAllCategories = false
    private var categories: [CategoryEntity] {
        isShowingAllCategories ? topCategories + otherCategories : topCategories
    }
    @State private var topCategories = [CategoryEntity]()
    @State private var otherCategories = [CategoryEntity]()
    @State private var selectedCategory: Int? = nil
    @State private var selectedProduct: ProductEntity? = nil
    private var categoriesInRow: Int {
        Int(UIScreen.main.bounds.width) / (67 + 16)
    }
    
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
            
            VStack {
                ForEach(categories.chunked(into: categoriesInRow), id: \.self) {
                    categoriesArray in
                    
                    HStack {
                        ForEach(categoriesArray, id: \.id) { category in
                            Button(
                                action: {
                                    if category.id == -1 {
                                        isShowingAllCategories.toggle()
                                    } else {
                                        if selectedCategory == category.id {
                                            selectedCategory = nil
                                        } else {
                                            selectedCategory = category.id
                                        }
                                    }
                                },
                                label: {
                                    CategoryView(
                                        category: category,
                                        isSelected: category.id == selectedCategory
                                    )
                                        .frame(width: 67)
                                }
                            )
                            Spacer()
                            if category != categoriesArray.last {
                                Spacer()
                            }
                        }
                        if categoriesArray.count != categoriesInRow {
                            Spacer()
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            
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
        .onChange(of: isShowingAllCategories) {
            topCategories[topCategories.count - 1] = $0 ? .top : .all
        }
        .animation(.linear, value: isShowingAllCategories)
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
            let sortedCategories = categoriesFrequency.sorted { $0.value > $1.value }.map { $0.key }
            if categories.isEmpty {
                topCategories = sortedCategories.prefix(categoriesInRow - 1) + [.all]
                if sortedCategories.count > categoriesInRow {
                    otherCategories = Array(sortedCategories[categoriesInRow...])
                }
            }
        case .failure(let error):
            print(error)
        }
    }
}

extension CategoryEntity {
    static let all: CategoryEntity = .init(id: -1, name: "All", image: "")
    static let top: CategoryEntity = .init(id: -1, name: "Top", image: "")
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    HomeScreen()
}
