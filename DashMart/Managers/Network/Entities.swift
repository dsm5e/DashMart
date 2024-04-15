//
//  ProductEntity.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation

struct ProductEntity: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [URL]
    let creationAt: Date
    let updatedAt: Date
    let category: CategoryEntity
}

struct CategoryEntity: Codable {
    let id: Int
    let name: String
    let image: URL
}
