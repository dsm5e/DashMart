//
//  HomeVM.swift
//  DashMart
//
//  Created by Ilya Paddubny on 27.04.2024.
//

import Foundation
import UIKit

class HomeVM: ObservableObject {
    @MainActor var products = [ProductEntity]()
    @MainActor var filteredProductsByCategory = [ProductEntity]() {
        didSet {
            sliderPosition = 0...Int(ceil(getMaxPrice()))
            priceBounds = 0...Int(ceil(getMaxPrice()))
        }
    }
    
    private var sortedFilteredProducts = [ProductEntity]() {
        didSet {
            objectWillChange.send()
        }
    }
    var filteredProducts: [ProductEntity] {
        return sortedFilteredProducts
    }
    
    @MainActor @Published var isShowingAllCategories = false
    
    
    @MainActor @Published var topCategories = [CategoryEntity]()
    @MainActor @Published var otherCategories = [CategoryEntity]()
    @MainActor @Published var selectedProduct: ProductEntity? = nil
    @MainActor @Published private(set) var loading = false
    
    @MainActor @Published var isFiltersApplied = false
    @MainActor @Published var sortType: SortType = .none
    
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
                filteredProductsByCategory = products.filter { $0.category.id == selectedCategory }
                updateSortedFilteredProducts()
                updateFiltersApplied()
            } else {
                filteredProductsByCategory = products // Reset to all products when no category selected
                updateSortedFilteredProducts()
                updateFiltersApplied()
            }
        }
    }
    
    @MainActor
    func getProducts() async {
        loading = true
        switch await NetworkService.client.sendRequest(request: ProductsRequest(categoryId: selectedCategory)) {
        case .success(let result):
            products = result
            filteredProductsByCategory = products
            updateSortedFilteredProducts()
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
        self?.sliderPosition = self?.priceBounds ?? 0...10
        self?.sortType = .none
        self?.updateFiltersApplied()
    }

    
    @MainActor
    lazy var applyFilter: (SortType, ClosedRange<Int>) -> Void = { [weak self] sortingType, range in
        self?.sliderPosition = range
        self?.sortType = sortingType
        self?.updateSortedFilteredProducts()
        self?.objectWillChange.send()
        self?.updateFiltersApplied()
    }
    
    @MainActor 
    func getMaxPrice() -> Double {
        return filteredProductsByCategory.max(by: { $0.price < $1.price })?.price ?? 10.0
    }
    
    @MainActor
    private func updateSortedFilteredProducts() {
        switch sortType {
        case .none:
            sortedFilteredProducts = filteredProductsByCategory.filter { ($0.price <= Double(sliderPosition.upperBound)) && ($0.price >= Double(sliderPosition.lowerBound)) }
        case .alphabeticalAscending:
            sortedFilteredProducts = filteredProductsByCategory.filter { ($0.price <= Double(sliderPosition.upperBound)) && ($0.price >= Double(sliderPosition.lowerBound)) }.sorted { $0.title < $1.title }
        case .alphabeticalDescending:
            sortedFilteredProducts = filteredProductsByCategory.filter { ($0.price <= Double(sliderPosition.upperBound)) && ($0.price >= Double(sliderPosition.lowerBound)) }.sorted { $0.title > $1.title }
        }
        
    }
    
    @MainActor
    private func updateFiltersApplied() {
        isFiltersApplied = (sortType != .none) || (sliderPosition != priceBounds)
    }
    
}
