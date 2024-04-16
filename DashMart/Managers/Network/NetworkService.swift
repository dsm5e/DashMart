//
//  NetworkManager.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation
import NetworkManager

final class NetworkService {
    
    static let client: NetworkClient = DefaultNetworkClient(baseURL: "https://api.escuelajs.co/api/v1/")
    
    private init() { }
}
