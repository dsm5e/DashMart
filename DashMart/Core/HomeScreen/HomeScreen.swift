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
    @ObservedObject var viewModel = HomeVM()
    
    @State private var searchInput: String = ""
    @State private var isShowingSearchResults = false
    @ObservedObject private var storage = StorageService.shared
    
    private var categories: [CategoryEntity] {
        viewModel.isShowingAllCategories ? viewModel.topCategories + viewModel.otherCategories : viewModel.topCategories
    }
    
    private var categoriesInRow: Int {
        Int(UIScreen.main.bounds.width) / 67
    }
    
    @State private var isShowingFilters = false
    @State private var isButtonActive = false
    @State private var filtersApplied = false
    @State private var minPrice: Double?
    @State private var maxPrice: Double?
    @State private var sortType: SortType = .none
    @State private var filterText = ""
    
    @State var sliderPosition: ClosedRange<Int> = 0...10
    
    var body: some View {
        VStack(spacing: 16) {
            NavBarMenu(
                storage: storage,
                location: .shared,
                cartButtonAction: {
                    viewModel.isShowingCard = true
                },
                locationAction: {
                    viewModel.isShowingLocation = true
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
            
            if viewModel.loading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                LazyVGrid(columns: (0..<categoriesInRow).map { _ in .init(.fixed(67)) }) {
                    ForEach(categories) { category in
                        Button(
                            action: {
                                if category.id == -1 {
                                    viewModel.isShowingAllCategories.toggle()
                                } else {
                                    if viewModel.selectedCategory == category.id {
                                        viewModel.selectedCategory = nil
                                    } else {
                                        viewModel.selectedCategory = category.id
                                    }
                                }
                            },
                            label: {
                                CategoryView(
                                    category: category,
                                    isSelected: category.id == viewModel.selectedCategory
                                )
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                VStack {
                    TitleFilters(text: "Products", action: {
                        isShowingFilters.toggle()
                    }, filtersApplied: $filtersApplied, isButtonActive: $isButtonActive)
                    .padding(.horizontal, 20)
                }
            }
            
            ScrollView {
                LazyVGrid(
                    columns: [.init(),.init()],
                    spacing: 8
                ) {
                    ForEach(viewModel.filteredProducts) { product in
                        Button(
                            action: {
                                viewModel.selectedProduct = product
                                viewModel.isShowingDetails = true
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
            viewModel.loading = true
            await getProducts()
            viewModel.loading = false
        }
        .onChange(of: viewModel.selectedCategory) { value in
            guard let value else {
                viewModel.filteredProducts = viewModel.products
                return
            }
            viewModel.filteredProducts = viewModel.products.filter { $0.category.id == value }
        }
        .onChange(of: viewModel.isShowingAllCategories) { _ in
            viewModel.topCategories[viewModel.topCategories.count - 1] = viewModel.isShowingAllCategories ? .top : .all
        }
        .animation(.linear, value: viewModel.isShowingAllCategories)
        .fullScreenCover(isPresented: $isShowingSearchResults) {
            SearchResultScreen(
                products: $viewModel.products
            )
        }
        .fullScreenCover(isPresented: $viewModel.isShowingDetails) {
            DetailScreen(product: $viewModel.selectedProduct)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingCard) {
            CartScreen()
        }
        .bottomSheet(isPresented: $viewModel.isShowingLocation, detents: [.medium()]) {
            CountrySelection()
        }
        .bottomSheet(isPresented: $isShowingFilters, detents: [.medium()]) {
            FilterBotomSheet(
                isPresented: $isShowingFilters,
                sortingOrder: $sortType,
                priceRange: $sliderPosition,
                applyAction: {print("apply")},
                clearAction: {print("clearAction")}
            )
        }
    }
    
    func applyFilters(closeBottomSheet: Bool = true) {
        
        var isFilterApplied = false
        
        if !filterText.isEmpty {
            viewModel.filteredProducts = viewModel.filteredProducts.filter { $0.title.localizedCaseInsensitiveContains(filterText) }
            isFilterApplied = true
        }
        
        if let minPrice = minPrice {
            viewModel.filteredProducts = viewModel.filteredProducts.filter { $0.price >= minPrice }
            isFilterApplied = true
        }
        
        if let maxPrice = maxPrice {
            if let minPrice = minPrice, maxPrice < minPrice {
                self.maxPrice = minPrice
            }
            viewModel.filteredProducts = viewModel.filteredProducts.filter { $0.price <= maxPrice }
            isFilterApplied = true
        }
        
        guard isFilterApplied || sortType != .none else {
            return
        }
        switch sortType {
        case .alphabeticalAscending:
            viewModel.filteredProducts.sort { $0.title < $1.title }
        case .alphabeticalDescending:
            viewModel.filteredProducts.sort { $0.title > $1.title }
        default:
            break
        }
        
        isButtonActive = !viewModel.filteredProducts.isEmpty
        
        if closeBottomSheet {
            isShowingFilters = false
        }
        
        filtersApplied = true
        
    }
    
    func clearFilters() {
        filterText = ""
        minPrice = nil
        maxPrice = nil
        sortType = .none
        applyFilters(closeBottomSheet: false)
        isButtonActive = false
        filtersApplied = false
    }
}

extension HomeScreen {
    func getProducts() async {
        switch await NetworkService.client.sendRequest(request: ProductsRequest(categoryId: viewModel.selectedCategory)) {
        case .success(let result):
            viewModel.products = result
            viewModel.filteredProducts = viewModel.products
            
            var categoriesFrequency = [CategoryEntity: Int]()
            viewModel.products.forEach {
                categoriesFrequency[$0.category] = categoriesFrequency[$0.category, default: 0] + 1
            }
            let sortedCategories = categoriesFrequency.sorted { $0.value > $1.value }.map { $0.key }
            if categories.isEmpty {
                viewModel.topCategories = sortedCategories.prefix(categoriesInRow - 1) + [.all]
                if sortedCategories.count + 1 > categoriesInRow {
                    viewModel.otherCategories = Array(sortedCategories[(categoriesInRow - 1)...])
                }
            }
        case .failure(let error):
            print(error)
            viewModel.loading = false
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

