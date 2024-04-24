//
//  HomeScreen.swift
//  DashMart
//
//  Created by dsm 5e on 14.04.2024.
//

import SwiftUI
import Kingfisher
import BottomSheet

struct HomeScreen: View {
    @State private var searchInput: String = ""
    @State private var isShowingSearchResults = false
    @State private var isShowingDetails = false
    @State private var isShowingCard = false
    @State private var isShowingLocation = false
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
    @State private var loading = false
    private var categoriesInRow: Int {
        Int(UIScreen.main.bounds.width) / 67
    }
    
    // Filter States
    @State private var isShowingFilters = false
    @State private var shouldCloseBottomSheet = false
    @State private var filterText = ""
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            NavBarMenu(
                storage: storage,
                location: .shared,
                cartButtonAction: {
                    isShowingCard = true
                },
                locationAction: {
                    isShowingLocation = true
                }
            )
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
            
            if loading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                LazyVGrid(columns: (0..<categoriesInRow).map { _ in .init(.fixed(67)) }) {
                    ForEach(categories) { category in
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
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                TitleFilters(text: "Products") {
                    isShowingFilters.toggle()
                }
                .padding(.horizontal, 20)
                
                ScrollView {
                    LazyVGrid(
                        columns: [.init(),.init()],
                        spacing: 8
                    ) {
                        ForEach(filteredProducts) { product in
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
        }
        .padding(.top)
        .task {
            loading = true
            await getProducts()
            loading = false
        }
        .onChange(of: selectedCategory) { value in
            guard let value else {
                filteredProducts = products
                return
            }
            filteredProducts = products.filter { $0.category.id == value }
        }
        .onChange(of: isShowingAllCategories) { _ in
            topCategories[topCategories.count - 1] = isShowingAllCategories ? .top : .all
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
        .fullScreenCover(isPresented: $isShowingCard) {
            CartScreen()
        }
        .bottomSheet(isPresented: $isShowingLocation, detents: [.medium()]) {
            CountrySelection()
        }
        .bottomSheet(isPresented: $isShowingFilters, detents: [.medium()]) {
            VStack(spacing: 16) {
                Text("Filter Products")
                    .font(.system(size: 16))
                    .padding()
                TextField("Filter by name", text: $filterText)
                    .padding(.bottom)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Text("Min Price:")
                    Slider(value: $minPrice, in: 0...1000, step: 1)
                        .tint(Color(hex: "#67C4A7"))
                    Text("\(Int(minPrice))")
                        .padding(.horizontal)
                }
                .onChange(of: minPrice) { _ in
                    applyFilters()
                }

                HStack {
                    Text("Max Price:")
                    Slider(value: $maxPrice, in: 0...1000, step: 1)
                        .tint(Color(hex: "#67C4A7"))
                    Text("\(Int(maxPrice))")
                        .padding(.horizontal)
                }
                .onChange(of: maxPrice) { _ in
                    applyFilters()
                }

                Spacer()
                
                Button("Apply", action: applyFilters)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .frame(width: 167, height: 45)
                    .background(Color(hex: "#67C4A7"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(.bottom, 50)
            }
               
            .padding(.horizontal)
            .background(Color.white)
        }
    }
    
    func applyFilters() {
        if filterText.isEmpty && minPrice == 0 && maxPrice == 1000 {
            isShowingFilters = false
            filteredProducts = products
            return
        }
        
        isShowingFilters = true
        filteredProducts = products.filter { product in
            let nameMatch = filterText.isEmpty || product.title.localizedCaseInsensitiveContains(filterText)
            let priceInRange = product.price >= minPrice && product.price <= maxPrice
            return nameMatch && priceInRange
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
                if sortedCategories.count + 1 > categoriesInRow {
                    otherCategories = Array(sortedCategories[(categoriesInRow - 1)...])
                }
            }
        case .failure(let error):
            print(error)
            loading = false
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
