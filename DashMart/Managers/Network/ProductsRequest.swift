//
//  ProductsRequest.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation
import NetworkManager

struct ProductsRequest: NetworkRequest {
    typealias Response = [ProductEntity]
    
    var url = "products"
    
    var method: NetworkManager.HTTPMethod {
        .GET
    }
    
    var parameters = [String : Any]()
    var body = [String : Any]()
    
    init(
        price: Double? = nil,
        priceMin: Double? = nil,
        priceMax: Double? = nil,
        categoryId: Int? = nil,
        limit: Int = 0,
        offset: Int = 1
    ) {
        parameters = [
            "limit": "\(limit)",
            "offset": "\(offset)",
        ]
        if let priceMin {
            parameters["price_min"] = "\(priceMin)"
        }
        if let priceMax {
            parameters["price_max"] = "\(priceMax)"
        }
        if let price {
            parameters["price"] = "\(price)"
        }
        if let categoryId {
            parameters["categoryId"] = "\(categoryId)"
        }
    }
}

struct ProductRequestGet: NetworkRequest {
    typealias Response = ProductEntity
    
    let id: Int
    
    var url: String {
        "products/\(id)"
    }
    var method: HTTPMethod {
        .GET
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
}

struct ProductRequestPost: NetworkRequest {
    typealias Response = ProductEntity
    
    var url: String {
        "products"
    }
    
    var method: HTTPMethod {
        .POST
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
    
    init(
        title: String,
        price: Double,
        description: String,
        categoryId: Int,
        images: [String]
    ) {
        body = [
            "title": title,
            "price": price,
            "description": description,
            "categoryId": categoryId,
            "images": images
        ]
    }
}

struct ProductRequestUpdate: NetworkRequest {
    typealias Response = ProductEntity
    
    let id: Int
    
    var url: String {
        "products/\(id)"
    }
    var method: HTTPMethod {
        .PUT
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
    
    init(
        id: Int,
        title: String,
        price: Double,
        description: String,
        categoryId: Int,
        images: [String]
    ) {
        self.id = id
        
        body["title"] = title
        body["price"] = price
        body["description"] = description
        body["categoryId"] = categoryId
        body["images"] = images
    }
}

struct ProductRequestDelete: NetworkRequest {
    typealias Response = Bool
    
    let id: Int
    
    var url: String {
        "products/\(id)"
    }
    var method: HTTPMethod {
        .DELETE
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
}
