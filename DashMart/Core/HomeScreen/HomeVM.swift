//
//  HomeVM.swift
//  DashMart
//
//  Created by Ilya Paddubny on 27.04.2024.
//

import Foundation
import UIKit

class HomeVM: ObservableObject {
    @MainActor @Published var products = [ProductEntity]()
    @MainActor @Published var filteredProducts = [ProductEntity]() {
        didSet {
            sliderPosition = 0...Int(ceil(getMaxPrice()))
            priceBounds = 0...Int(ceil(getMaxPrice()))
        }
    }
    
    @MainActor @Published var isShowingAllCategories = false
    
    
    @MainActor @Published var topCategories = [CategoryEntity]()
    @MainActor @Published var otherCategories = [CategoryEntity]()
    @MainActor @Published var selectedProduct: ProductEntity? = nil
    @MainActor @Published private(set) var loading = false
    
    @MainActor @Published var isShowingFilters = false
    @MainActor @Published var isButtonActive = false
    
    @MainActor @Published var filtersApplied = false
    
    @MainActor @Published var minPrice: Double?
    @MainActor @Published var maxPrice: Double?
    @MainActor @Published var sortType: SortType = .none
    
    @MainActor @Published var filterText = ""
    
    @MainActor @Published var sliderPosition: ClosedRange<Int> = 0...10
    @MainActor @Published var priceBounds: ClosedRange<Int> = 0...10
    
    @MainActor var categories: [CategoryEntity] {
        isShowingAllCategories ? topCategories + otherCategories : topCategories
    }
    
    var categoriesInRow: Int {
        Int(UIScreen.main.bounds.width) / 67
    }
    
    @MainActor @Published var selectedCategory: Int? = nil {
        didSet {
            if let selectedCategory = selectedCategory {
                filteredProducts = products.filter { $0.category.id == selectedCategory }
            } else {
                filteredProducts = products // Reset to all products when no category selected
            }
        }
    }
    
    @MainActor
    func getProducts() async {
        loading = true
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
            loading = false
        case .failure(let error):
            print(error)
            loading = false
        }
    }
    
    @MainActor
    lazy var clearFilter: (() -> Void) = { [weak self] in
//        self?.filteredProducts = self?.products ?? []
        print(self?.getMaxPrice())
    }

    
    @MainActor
    lazy var applyFilter: (SortType, ClosedRange<Int>) -> Void = { [weak self] sortingType, range in
        print(range.upperBound)
    }
    
    @MainActor 
    func getMaxPrice() -> Double {
        return filteredProducts.max(by: { $0.price < $1.price })?.price ?? 10.0
    }
    
}
