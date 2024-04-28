//
//  SearchResultVM.swift
//  DashMart
//
//  Created by Ilya Paddubny on 28.04.2024.
//

import Foundation

class SearchResultVM: ObservableObject {
    
    @MainActor @Published var sliderPosition: ClosedRange<Int> = 0...10
    @MainActor @Published var priceBounds: ClosedRange<Int> = 0...10
    @MainActor @Published var sortType: SortType = .none
    
    @MainActor @Published var isFiltersApplied = false
    
    @Published var products: [ProductEntity]
    
    @MainActor @Published var filteredProductsByUserInput = [ProductEntity]() {
        didSet {
            updateSortedFilteredProducts()
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
    
    @MainActor
    init(products: [ProductEntity]) {
        self.products = products
        sliderPosition = 0...Int(ceil(products.max(by: { $0.price < $1.price })?.price ?? 10.0))
        priceBounds = 0...Int(ceil(products.max(by: { $0.price < $1.price })?.price ?? 10.0))
    }
    
    @MainActor
    lazy var clearFilter: (() -> Void) = { [weak self] in
        self?.sliderPosition = self?.priceBounds ?? 0...10
        self?.updateSortedFilteredProducts()
    }

    
    @MainActor
    lazy var applyFilter: (SortType, ClosedRange<Int>) -> Void = { [weak self] _, range in
        self?.sliderPosition = range
        self?.updateSortedFilteredProducts()
        self?.objectWillChange.send()
//        self?.updateFiltersApplied()
    }
    
    @MainActor
    func getMaxPrice() -> Double {
        return products.max(by: { $0.price < $1.price })?.price ?? 10.0
    }
    
    @MainActor
    private func updateSortedFilteredProducts() {
        sortedFilteredProducts = filteredProductsByUserInput.filter { ($0.price <= Double(sliderPosition.upperBound)) && ($0.price >= Double(sliderPosition.lowerBound)) }
        updateFiltersApplied()
    }
    
    @MainActor
    private func updateFiltersApplied() {
        isFiltersApplied = sliderPosition != priceBounds
    }
    
}
