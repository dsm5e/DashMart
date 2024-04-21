//
//  ProductEntity.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation

struct ProductEntity: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]
    let creationAt: Date?
    let updatedAt: Date?
    let category: CategoryEntity
}

struct CategoryEntity: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let image: String
}
