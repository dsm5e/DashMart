//
//  NetworkRequest.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

public protocol NetworkRequest {
    associatedtype Response: Decodable
    
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var body: [String: Any] { get }
}
