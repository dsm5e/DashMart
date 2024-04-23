//
//  NetworkError.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidDecoding
    case failedRequest
    case invalidStatusCode(Int)
    case apiError(NetworkErrorEntity?)
    case `internal`(Error)
}

public struct NetworkErrorEntity: Codable {
    public let message: [String]
    public let error: String
    public let statusCode: Int
}
