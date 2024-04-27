//
//  SearchResultScreen.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct SearchResultScreen: View {
    @State var searchInput: String = ""
    @Binding var products: [ProductEntity]
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var storage = StorageService.shared
    @State private var filteredProducts = [ProductEntity]()
    @FocusState private var focused: Bool?
    @State private var selectedProduct: ProductEntity? = nil
    @State private var isDetailsPresented = false
    @State private var isCartPresented = false
    @State private var keyboardHeight: CGFloat = .zero
    @State private var isShowingSearchHistory = true
    
    
    @State private var isShowingFilters = false
    @State private var isButtonActive = false
    @State private var filtersApplied = false
    @State private var minPrice: Double?
    @State private var maxPrice: Double?
    @State private var filterText = ""
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(Color(hex: "#393F42"))
                }
                
                SearchTextField(searchInput: $searchInput)
                    .focused($focused, equals: true)
                
                CartButton(
                    storage: storage,
                    action: {
                        isCartPresented = true
                    }
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 14)
            
            SeparatorView()
                .padding(.bottom, 16)
            
            if isShowingSearchHistory {
                SearchHistoryList()
            } else {
                VStack {
                    TitleFilters(text: "Products", action: {
                        isShowingFilters.toggle()
                    }, filtersApplied: $filtersApplied)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                    .bottomSheet(isPresented: $isShowingFilters, detents: [.medium()]) {
                        VStack(spacing: 16) {
                            Text("Filter Products")
                                .font(.system(size: 16))
                                .foregroundStyle(Color(hex: "#393F42"))
                                .padding()
                            
                            HStack {
                                Text("Price")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color(hex: "#393F42"))
                                Spacer()
                            }
                            .padding(.horizontal)
                            HStack {
                                TextField("Min", text: Binding<String>(
                                    get: { minPrice.map { String($0) } ?? "" },
                                    set: { minPrice = Double($0) }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Image(systemName: "ellipsis")
                                
                                Spacer()
                                TextField("Max", text: Binding<String>(
                                    get: { maxPrice.map { String($0) } ?? "" },
                                    set: { maxPrice = Double($0) }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 40)
                        }
                        HStack {
                            Button(
                                action: {
                                    clearFilters()
                                }, label: {
                                    Text("Clear Filter")
                                        .foregroundStyle(Color(hex: "#E53935"))
                                        .modifier(DashRoundedTitle(style: .gray))
                                }
                            )
                            
                            Button(
                                action: {
                                    applyFilters()
                                }, label: {
                                    Text("Apply")
                                        .modifier(DashRoundedTitle())
                                }
                            )
                        }
                        .padding(.horizontal)
                        .background(Color.white)
                    }
                }
            }
            
            if !searchInput.isEmpty {
                ScrollView {
                    LazyVGrid(
                        columns: [.init(),.init()],
                        spacing: 8
                    ) {
                        ForEach(filteredProducts) { product in
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
        }
        .ignoresSafeArea(edges: .bottom)
        .onChange(of: searchInput) { value in
            guard !value.isEmpty else {
                filteredProducts = products
                isShowingSearchHistory = true
                return
            }
            
            filteredProducts = products.filter { $0.title.contains(value) }
            isShowingSearchHistory = false
        }
        .onAppear {
            filteredProducts = products
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
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            if !searchInput.isEmpty {
                storage.saveSearchHistory(searchInput)
            }
        }
    }
    
    func applyFilters(closeBottomSheet: Bool = true) {
        filteredProducts = products
        
        var isFilterApplied = false
        
        if !filterText.isEmpty {
            filteredProducts = filteredProducts.filter { $0.title.localizedCaseInsensitiveContains(filterText) }
            isFilterApplied = true
        }
        
        if let minPrice = minPrice {
            filteredProducts = filteredProducts.filter { $0.price >= minPrice }
            isFilterApplied = true
        }
        
        if let maxPrice = maxPrice {
            if let minPrice = minPrice, maxPrice < minPrice {
                self.maxPrice = minPrice
            }
            filteredProducts = filteredProducts.filter { $0.price <= maxPrice }
            isFilterApplied = true
        }
        
        isButtonActive = !filteredProducts.isEmpty
        
        if closeBottomSheet {
            isShowingFilters = false
        }
        
        filtersApplied = true
        
    }
    
    func clearFilters() {
        filterText = ""
        minPrice = nil
        maxPrice = nil
        applyFilters(closeBottomSheet: false)
        isButtonActive = false
        filtersApplied = false
    }
}


