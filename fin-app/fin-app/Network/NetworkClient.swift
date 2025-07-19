//
//  NetworkClient.swift
//  fin-app
//
//  Created by Evelina on 14.07.2025.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T:Encodable, U: Decodable>(with data: T, endpoint: EndpointProtocol) async throws -> U
    func request<U: Decodable>(endpoint: EndpointProtocol) async throws -> U
    func request(endpoint: EndpointProtocol) async throws
}

struct Empty: Encodable {}

final class NetworkClient: NetworkClientProtocol {
    
    private let token: String
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init() {
        self.token = "POF3GvINBhxG3SiS5WK7Ouzg"
        self.urlSession = URLSession.shared
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
    
    func request<T:Encodable, U: Decodable>(with data: T, endpoint: EndpointProtocol) async throws -> U {
        let encodedData = try await encode(data)
        let urlRequest = try await makeURLRequest(endpoint: endpoint, data: encodedData)
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return try await decode(data)
        } catch {
            print(error)
            if error is DecodingError {
                throw NetworkError.decodingFailed
            } else {
                throw NetworkError.requestError
            }
        }
    }
    
    func request<U: Decodable>(endpoint: EndpointProtocol) async throws -> U {
        let urlRequest = try await makeURLRequest(endpoint: endpoint)
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return try await decode(data)
        } catch {
            print(error)
            if error is DecodingError {
                throw NetworkError.decodingFailed
            } else {
                throw NetworkError.requestError
            }
        }
    }
    
    func request(endpoint: EndpointProtocol) async throws {
        let urlRequest = try await makeURLRequest(endpoint: endpoint)
        do {
            _ = try await urlSession.data(for: urlRequest)
        } catch {
            print(error)
            throw NetworkError.requestError
        }
    }
    
    private func makeURLRequest(endpoint: EndpointProtocol, data: Data? = nil) async throws -> URLRequest {
        guard let url = URL(string: endpoint.host + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let data = data, endpoint.hasBody {
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
    
    private func decode<T: Decodable>(_ data: Data) async throws -> T {
        try await Task.detached(priority: .userInitiated) {  try self.decoder.decode(T.self, from: data) }.value
    }
    
    private func encode<T: Encodable>(_ data: T) async throws -> Data {
        try await Task.detached(priority: .userInitiated) { try self.encoder.encode(data) }.value
    }
}
