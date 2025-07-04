//
//  MyCategoriesViewModel.swift
//  fin-app
//
//  Created by Evelina on 01.07.2025.
//

import Foundation
import SwiftUI

final class MyCategoriesViewModel: ObservableObject {
    
    @Published var categoriesToView: [Category] = []
    private var categories: [Category] = []
    private let categoriesService: CategoriesService
    private let fuzzySearchHelper: FuzzySearchHelperProtocol
    
    init(categoriesService: CategoriesService, fuzzySearchHelper: FuzzySearchHelperProtocol) {
        self.categoriesService = categoriesService
        self.fuzzySearchHelper = fuzzySearchHelper
    }
    
    func fetchCategories() async {
        do {
            let categories = try await categoriesService.fetchAllCategories()
            await updateCategoriesToView(categories)
            await updateCategories(categories)
        } catch {
            
        }
    }
    
    func filterCategories(by searchText: String) {
        guard !searchText.isEmpty else {
            categoriesToView = categories
            return
        }
    
        Task {
            let filteredCategories = fuzzySearchHelper.fuzzySearch(for: categories, with: searchText)
            await updateCategoriesToView(filteredCategories)
        }
    }
    
    @MainActor
    private func updateCategoriesToView(_ categories: [Category]) {
        self.categoriesToView = categories
    }
    
    @MainActor
    private func updateCategories(_ categories: [Category]) {
        self.categories = categories
    }
}
