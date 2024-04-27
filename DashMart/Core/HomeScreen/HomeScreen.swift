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
    @StateObject var viewModel = HomeVM()
    @State private var searchInput: String = ""
    
    @State private var isShowingSearchResults = false
    @State private var isShowingAllCategories = false
    @State private var isShowingDetails = false
    @State private var isShowingCard = false
    @State private var isShowingLocation = false
    
    @ObservedObject private var storage = StorageService.shared
    
    
    var body: some View {
        VStack(spacing: 16) {
            navigationSection
                .padding(.horizontal, 20)
            
            searchSection
                .padding(.horizontal, 20)
            
            if viewModel.loading {
                progressView
            } else {
                categoriesSection
                filterSection
                productsSection
            }
        }
        .padding(.top)
        .task {
            await viewModel.getProducts()
        }
        .onChange(of: isShowingAllCategories) { _ in
            viewModel.topCategories[viewModel.topCategories.count - 1] = viewModel.isShowingAllCategories ? .top : .all
        }
        .animation(.linear, value: viewModel.isShowingAllCategories)
        .fullScreenCover(isPresented: $isShowingSearchResults) {
            SearchResultScreen(products: $viewModel.products)
        }
        .fullScreenCover(isPresented: $isShowingDetails) {
            DetailScreen(product: $viewModel.selectedProduct)
        }
        .fullScreenCover(isPresented: $isShowingCard) {
            CartScreen()
        }
        .bottomSheet(isPresented: $isShowingLocation, detents: [.medium()]) {
            CountrySelection()
        }
        .bottomSheet(isPresented: $viewModel.isShowingFilters, detents: [.medium()]) {
            FilterBotomSheet(
                isPresented: $viewModel.isShowingFilters,
                sortingOrder: $viewModel.sortType,
                priceBounds: $viewModel.priceBounds,
                priceRange: viewModel.sliderPosition,
                applyAction: viewModel.applyFilter,
                clearAction: viewModel.clearFilter
            )
        }
        
        
    }
    
    //MARK: main sections
    private var searchSection: some View {
        Button(
            action: {
                isShowingSearchResults = true
            },
            label: {
                SearchTextField(searchInput: $searchInput)
                    .disabled(true)
            }
        )
    }
    
    private var progressView: some View {
        Group {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    private var categoriesSection: some View {
        LazyVGrid(columns: (0..<viewModel.categoriesInRow).map { _ in .init(.fixed(67)) }) {
            ForEach(viewModel.categories) { category in
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
    }
    
    private var filterSection: some View {
        VStack {
            TitleFilters(text: "Products", action: {
                viewModel.isShowingFilters.toggle()
            }, filtersApplied: $viewModel.filtersApplied, isButtonActive: $viewModel.isButtonActive)
            .padding(.horizontal, 20)
        }
    }
    
    private var productsSection: some View {
        ScrollView {
            LazyVGrid(
                columns: [.init(),.init()],
                spacing: 8
            ) {
                ForEach(viewModel.filteredProducts) { product in
                    Button(
                        action: {
                            viewModel.selectedProduct = product
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
    
    private var navigationSection: some View {
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
    }
    
    func applyFilters(closeBottomSheet: Bool = true) {
        
        var isFilterApplied = false
        
        if !viewModel.filterText.isEmpty {
            viewModel.filteredProducts = viewModel.filteredProducts.filter { $0.title.localizedCaseInsensitiveContains(viewModel.filterText) }
            isFilterApplied = true
        }
        
        if let minPrice = viewModel.minPrice {
            viewModel.filteredProducts = viewModel.filteredProducts.filter { $0.price >= minPrice }
            isFilterApplied = true
        }
        
        if let maxPrice = viewModel.maxPrice {
            if let minPrice = viewModel.minPrice, maxPrice < minPrice {
                viewModel.maxPrice = minPrice
            }
            viewModel.filteredProducts = viewModel.filteredProducts.filter { $0.price <= maxPrice }
            isFilterApplied = true
        }
        
        guard isFilterApplied || viewModel.sortType != .none else {
            return
        }
        switch viewModel.sortType {
        case .alphabeticalAscending:
            viewModel.filteredProducts.sort { $0.title < $1.title }
        case .alphabeticalDescending:
            viewModel.filteredProducts.sort { $0.title > $1.title }
        default:
            break
        }
        
        viewModel.isButtonActive = !viewModel.filteredProducts.isEmpty
        
        if closeBottomSheet {
            viewModel.isShowingFilters = false
        }
        
        viewModel.filtersApplied = true
        
    }
    
    func clearFilters() {
        viewModel.filterText = ""
        viewModel.minPrice = nil
        viewModel.maxPrice = nil
        viewModel.sortType = .none
        applyFilters(closeBottomSheet: false)
        viewModel.isButtonActive = false
        viewModel.filtersApplied = false
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

