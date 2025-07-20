//
//  CategorySwiftDataCache.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation
import SwiftUI
import SwiftData

protocol CategoryCacheProtocol {
    func getAllCategories() async throws -> [Category]
    func saveCategories(_ categories: [Category]) async throws
}

actor CategorySwiftDataCache: ModelActor, CategoryCacheProtocol {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    private var modelContext: ModelContext {
        modelExecutor.modelContext
    }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelExecutor = DefaultSerialModelExecutor(
            modelContext: ModelContext(modelContainer)
        )
    }
    
    func getAllCategories() async throws -> [Category] {
        let categoryDescriptor = FetchDescriptor<CategoryCacheModel>(
            predicate: nil,
            sortBy: [.init(\.id)]
        )
        let categories = try modelContext.fetch(categoryDescriptor)
        return categories.map { category in
            Category(
                id: category.id,
                name: category.name,
                emoji: category.emoji.first ?? " ",
                isIncome: category.isIncome ? .income : .outcome
            )
        }
    }
        
    func saveCategories(_ categories: [Category]) async throws {
        let existingCategories = try modelContext.fetch(
            FetchDescriptor<CategoryCacheModel>(predicate: nil)
        )
        
        for existingCategory in existingCategories {
            modelContext.delete(existingCategory)
        }
        
        for category in categories {
            let categoryModel = CategoryCacheModel(from: category)
            print(category)
            modelContext.insert(categoryModel)
        }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
}
