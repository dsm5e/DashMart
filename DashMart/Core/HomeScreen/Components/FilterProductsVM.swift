//
//  FilterProductsVM.swift
//  DashMart
//
//  Created by Максим Самороковский on 26.04.2024.
//

import SwiftUI

struct FilterProductsVM: View {
    @State private var products = [ProductEntity]()
    @State private var filteredProducts = [ProductEntity]()
    @State private var isShowingFilters = false
    @State private var minPrice: Double?
    @State private var maxPrice: Double?
    @State private var sortType: SortType = .none
    @State private var isButtonActive = false
    @State private var filtersApplied = false
    @State private var searchInput: String = ""
    
    @State private var filterText = ""

    var showAlphabeticalSort: Bool
    
    init(showAlphabeticalSort: Bool) {
        self.showAlphabeticalSort = showAlphabeticalSort
    }
   
    
    var body: some View {
//        VStack {
//            TitleFilters(text: "Products", action: {
//                isShowingFilters.toggle()
//            }, filtersApplied: $filtersApplied, isButtonActive: $isButtonActive)
//            .bottomSheet(isPresented: $isShowingFilters, detents: [.medium()]) {
                VStack(spacing: 16) {
                    Text("Filter Products")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(hex: "#393F42"))
                        .padding()
                    if showAlphabeticalSort {
                        Picker(selection: $sortType, label: Text("Sort by")) {
                            Text("None").tag(SortType.none)
                            Text("A-Z").tag(SortType.alphabeticalAscending)
                            Text("Z-A").tag(SortType.alphabeticalDescending)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
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
//       }
//    }
    
    enum SortType {
        case none
        case alphabeticalAscending
        case alphabeticalDescending
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
                self.maxPrice = minPrice + 5
            }
            filteredProducts = filteredProducts.filter { $0.price <= maxPrice }
            isFilterApplied = true
        }
        
        guard isFilterApplied || sortType != .none else {
            return
        }
        
        if showAlphabeticalSort {
            switch sortType {
            case .alphabeticalAscending:
                filteredProducts.sort { $0.title < $1.title }
            case .alphabeticalDescending:
                filteredProducts.sort { $0.title > $1.title }
            default:
                break
            }
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
        sortType = .none
        applyFilters(closeBottomSheet: false)
        isButtonActive = false
        filtersApplied = false
    }
}


#Preview {
    FilterProductsVM(showAlphabeticalSort: true)
}


