//
//  SearchResultScreen.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct SearchResultScreen: View {
    @StateObject var viewModel: SearchResultVM
    @State var searchInput: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var storage = StorageService.shared
    
    @FocusState private var focused: Bool?
    @State private var selectedProduct: ProductEntity? = nil
    
    
    @State private var isDetailsPresented = false
    @State private var isCartPresented = false
    @State private var keyboardHeight: CGFloat = .zero
    @State private var isShowingSearchHistory = true
    
    
    @State private var isShowingFilters = false
    @State private var isButtonActive = false
    
    @State private var minPrice: Double?
    @State private var maxPrice: Double?
    
    init(products: [ProductEntity]) {
        _viewModel = StateObject(wrappedValue: SearchResultVM(products: products))
    }
    
    var body: some View {
        VStack {
            searchSection
            .padding(.horizontal, 20)
            .padding(.bottom, 14)
            
            SeparatorView()
                .padding(.bottom, 16)
            
            if isShowingSearchHistory {
                SearchHistoryList(selectHistoryItemAction: searchHistoryItemSelected)
            } else {
                filterSection
            }
            
            if !searchInput.isEmpty {
                productsSection
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onChange(of: searchInput) { value in
            guard !value.isEmpty else {
                viewModel.filteredProductsByUserInput = viewModel.products
                isShowingSearchHistory = true
                return
            }
            
            viewModel.filteredProductsByUserInput = viewModel.products.filter { $0.title.contains(value) }
            isShowingSearchHistory = false
        }
        .onAppear {
            viewModel.filteredProductsByUserInput = viewModel.products
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focused = true
            }
        }
        .onTapGesture {
            endTextEditing()
        }
        .fullScreenCover(isPresented: $isDetailsPresented) {
            DetailScreen(product: $selectedProduct)
        }
        .fullScreenCover(isPresented: $isCartPresented) {
            CartScreen()
        }
        .bottomSheet(isPresented: $isShowingFilters, detents: [.medium()]) {
            FilterBotomSheet(
                isPresented: $isShowingFilters,
                sortingOrder: $viewModel.sortType,
                priceBounds: $viewModel.priceBounds,
                priceRange: viewModel.sliderPosition,
                applyAction: viewModel.applyFilter,
                clearAction: viewModel.clearFilter,
                isSortingOrderPresented: false
            )
        }
    }
    
    private var searchSection: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundStyle(Color(hex: "#393F42"))
            }
            
            SearchTextField(searchInput: $searchInput)
                .focused($focused, equals: true)
                .onSubmit {
                    if !searchInput.isEmpty {
                        storage.saveSearchHistory(searchInput)
                    }
                }
            
            CartButton(
                storage: storage,
                action: {
                    isCartPresented = true
                }
            )
        }
    }
    
    private var productsSection: some View {
        ScrollView {
            LazyVGrid(
                columns: [.init(),.init()],
                spacing: 8
            ) {
                ForEach(viewModel.filteredProducts) { product in
                    Button(action: {
                        selectedProduct = product
                        isDetailsPresented = true
                    }) {
                        ProductItem(
                            product: product,
                            storage: storage,
                            showWishlistButton: false
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }
    
    private var filterSection: some View {
        VStack {
            TitleFilters(text: "Products", action: {
                isShowingFilters.toggle()
            }, filtersApplied: $viewModel.isFiltersApplied)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
    }
    
    func searchHistoryItemSelected(_ query: String) {
        searchInput = query
    }
}



