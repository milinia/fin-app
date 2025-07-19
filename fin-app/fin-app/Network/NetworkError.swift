//
//  NetworkError.swift
//  fin-app
//
//  Created by Evelina on 16.07.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case requestError
    case encodingFailed
    case unknown
}
