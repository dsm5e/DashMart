//
//  HomeScreen.swift
//  DashMart
//
//  Created by Ilya Paddubny on 27.04.2024.
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
    @State var isShowingFilters = false
    
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
        .bottomSheet(isPresented: $isShowingFilters, detents: [.medium()]) {
            FilterBotomSheet(
                isPresented: $isShowingFilters,
                sortingOrder: $viewModel.sortType,
                priceBounds: $viewModel.priceBounds,
                priceRange: viewModel.sliderPosition,
                applyAction: viewModel.applyFilter,
                clearAction: viewModel.clearFilter
            )
        }
        
        
    }
    
    //MARK: views
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
            TitleFilters(text: "Products",
                         action: {
                isShowingFilters.toggle()
            }, filtersApplied: $viewModel.isFiltersApplied)
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

