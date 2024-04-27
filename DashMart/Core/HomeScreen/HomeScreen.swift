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
            VStack(spacing: 10) {
                Text("Apply filter by")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundStyle(Color(hex: "#393F42"))
                    .padding()
                Text("Product name")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(Color(hex: "#393F42"))
                Picker(selection: $sortType, label: Text("Sort by")) {
                    Text("None").tag(SortType.none)
                    Text("A-Z").tag(SortType.alphabeticalAscending)
                    Text("Z-A").tag(SortType.alphabeticalDescending)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text("Price range")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(Color(hex: "#393F42"))
                RangedSliderView(value: $sliderPosition, bounds: 0...10)
                    .padding(.leading, 48)
                    .padding(.trailing, 48)
//                            HStack {
//                                Text("Price")
//                                    .font(.system(size: 16))
//                                    .foregroundStyle(Color(hex: "#393F42"))
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//                            HStack {
//                                TextField("Min", text: Binding<String>(
//                                    get: { minPrice.map { String($0) } ?? "" },
//                                    set: { minPrice = Double($0) }
//                                ))
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                                Image(systemName: "ellipsis")
//
//                                Spacer()
//                                TextField("Max", text: Binding<String>(
//                                    get: { maxPrice.map { String($0) } ?? "" },
//                                    set: { maxPrice = Double($0) }
//                                ))
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                            }
//                            .padding(.horizontal)
//                            .padding(.bottom, 40)
            }
            HStack {
                Button(
                    action: {
                        clearFilters()
                        sliderPosition = 0...sliderPosition.upperBound
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
                self.maxPrice = minPrice
            }
            filteredProducts = filteredProducts.filter { $0.price <= maxPrice }
            isFilterApplied = true
        }
        
        guard isFilterApplied || sortType != .none else {
            return
        }
        switch sortType {
        case .alphabeticalAscending:
            filteredProducts.sort { $0.title < $1.title }
        case .alphabeticalDescending:
            filteredProducts.sort { $0.title > $1.title }
        default:
            break
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

