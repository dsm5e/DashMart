//
//  HomeVM.swift
//  DashMart
//
//  Created by Ilya Paddubny on 27.04.2024.
//

import Foundation

class HomeVM: ObservableObject {
    @Published var products = [ProductEntity]()
    @Published var filteredProducts = [ProductEntity]()
    @Published var isShowingAllCategories = false
    @Published var isShowingDetails = false
    @Published var isShowingCard = false
    @Published var isShowingLocation = false
    
    @Published var topCategories = [CategoryEntity]()
    @Published var otherCategories = [CategoryEntity]()
    @Published var selectedCategory: Int? = nil
    @Published var selectedProduct: ProductEntity? = nil
    @Published var loading = false
    
}
