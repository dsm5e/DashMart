//
//  SearchResultScreen.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct SearchResultScreen: View {
    @Binding var searchInput: String
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
                TitleFilters(text: "Search result for \(searchInput)")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
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
    }
}
