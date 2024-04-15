//
//  CategoriesRequest.swift
//  DashMart
//
//  Created by Victor Rubenko on 15.04.2024.
//

import Foundation
import NetworkManager

struct CategoriesRequest: NetworkRequest {
    typealias Response = [CategoryEntity]
    
    var url = "categories"
    
    var method: NetworkManager.HTTPMethod {
        .GET
    }
    
    var parameters = [String : Any]()
    var body = [String : Any]()
}

struct CagetegoryRequestGet: NetworkRequest {
    typealias Response = CategoryEntity
    
    let id: Int
    
    var url: String {
        "categories/\(id)"
    }
    var method: HTTPMethod {
        .GET
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
}

struct CategoryRequestPost: NetworkRequest {
    typealias Response = ProductEntity
    
    var url: String {
        "categories"
    }
    
    var method: HTTPMethod {
        .POST
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
    
    init(
        name: String,
        image: URL
    ) {
        body = [
            "name": name,
            "image": image.absoluteString
        ]
    }
}

struct CategoryRequestUpdate: NetworkRequest {
    typealias Response = CategoryEntity
    
    let id: Int
    
    var url: String {
        "products/\(id)"
    }
    var method: HTTPMethod {
        .GET
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
    
    init(
        id: Int,
        name: String?,
        image: URL?
    ) {
        self.id = id
        
        body["name"] = name
        body["image"] = image?.absoluteString
    }
}

struct CategoryRequestDelete: NetworkRequest {
    typealias Response = Bool
    
    let id: Int
    
    var url: String {
        "categories/\(id)"
    }
    var method: HTTPMethod {
        .DELETE
    }
    var parameters = [String : Any]()
    var body = [String : Any]()
}
