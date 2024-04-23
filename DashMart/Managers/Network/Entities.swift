//
//  ProductEntity.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation

struct ProductEntity: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]
    let creationAt: Date?
    let updatedAt: Date?
    let category: CategoryEntity
    
    var fixedImages: [String] {
        images.map {
            $0.replacingOccurrences(of: "\"", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
        }
    }
}

struct CategoryEntity: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let image: String
    
    static let mock: Self = .init(
        id: 0,
        name: "Electronics",
        image: "https://category.image"
    )
}
