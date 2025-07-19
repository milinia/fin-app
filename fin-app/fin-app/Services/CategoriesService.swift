//
//  CategoriesService.swift
//  fin-app
//
//  Created by Evelina on 10.06.2025.
//

import Foundation

protocol CategoriesServiceProtocol {
    func fetchAllCategories() async throws -> [Category]
    func fetchCategories(by: Direction) async throws -> [Category]
}

final class CategoriesService: CategoriesServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    private let categoriesCache: CategoryCacheProtocol
    
    init(networkClient: NetworkClientProtocol, categoriesCache: CategoryCacheProtocol) {
        self.networkClient = networkClient
        self.categoriesCache = categoriesCache
    }
    
    func fetchAllCategories() async throws -> [Category] {
        do {
            let categories: [Category] = try await networkClient.request(endpoint: CategoriesEndpoints.getCategories)
            try await categoriesCache.saveCategories(categories)
            return categories
        } catch {
            return try await categoriesCache.getAllCategories()
        }
    }
    
    func fetchCategories(by direction: Direction) async throws -> [Category] {
        do {
            let categories: [Category] = try await networkClient.request(endpoint: CategoriesEndpoints.getCategoriesBy(direction: direction))
            try await categoriesCache.saveCategories(categories)
            return categories
        } catch {
            var categories = try await categoriesCache.getAllCategories()
            categories = categories.filter { $0.isIncome == direction }
            return categories
        }
    }
}
