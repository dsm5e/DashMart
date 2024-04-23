//
//  NetworkProtocols.swift
//  DashMart
//
//  Created by Victor on 15.04.2024.
//

import Foundation

import Foundation

public protocol NetworkClient {
    func sendRequest<Request>(request: Request) async -> Result<Request.Response, NetworkError> where Request: NetworkRequest
}

public actor DefaultNetworkClient: NetworkClient {
    
    private let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func sendRequest<Request>(request: Request) async -> Result<Request.Response, NetworkError> where Request: NetworkRequest {
        let fullURL = request.url.starts(with: "https") ? request.url : baseURL + request.url
        guard var urlComponents = URLComponents(string: fullURL) else {
            return .failure(.invalidURL)
        }
        if !request.parameters.isEmpty {
            urlComponents.queryItems = request.parameters.compactMap {
                if let value = $0.value as? String {
                    return URLQueryItem(name: $0.key, value: value)
                } else {
                    return nil
                }
            }
            request.parameters.forEach {
                item in
                
                if let value = item.value as? [String] {
                    urlComponents.queryItems?.append(contentsOf: value.map { .init(name: item.key, value: $0) })
                }
            }
        }
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        
        if !request.body.isEmpty {
            switch request.method {
            case .POST, .PUT:
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.body, options: [.prettyPrinted])
            default:
                break
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidDecoding)
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard let decoded = try? decoder.decode(Request.Response.self, from: data) else {
                    return .failure(.invalidDecoding)
                }
                return .success(decoded)
            default:
                return .failure(.apiError(try? JSONDecoder().decode(NetworkErrorEntity.self, from: data)))
            }
        } catch {
            return .failure(.internal(error))
        }
    }
}
