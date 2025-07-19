//
//  MyCategoriesViewModel.swift
//  fin-app
//
//  Created by Evelina on 01.07.2025.
//

import Foundation
import SwiftUI

final class MyCategoriesViewModel: LoadableObject {
    typealias DataType = [Category]
    
    @Published var state: LoadingState<[Category]> = .loading
    private var categories: [Category] = []
    private let categoriesService: CategoriesServiceProtocol
    private let fuzzySearchHelper: FuzzySearchHelperProtocol
    
    init(categoriesService: CategoriesServiceProtocol, fuzzySearchHelper: FuzzySearchHelperProtocol) {
        self.categoriesService = categoriesService
        self.fuzzySearchHelper = fuzzySearchHelper
    }
    
    func fetchCategories() async {
        await setStateLoading()
        do {
            let categories = try await categoriesService.fetchAllCategories()
            await updateCategoriesToView(categories)
            await updateCategories(categories)
        } catch {
            await setError(error: error)
        }
    }
    
    func filterCategories(by searchText: String) {
        guard !searchText.isEmpty else {
            self.state = .completed(categories)
            return
        }
    
        Task {
            let filteredCategories = fuzzySearchHelper.fuzzySearch(for: categories, with: searchText)
            await updateCategoriesToView(filteredCategories)
        }
    }
    
    @MainActor
    private func setStateLoading() {
        self.state = .loading
    }
    
    @MainActor
    private func setError(error: Error) {
        self.state = .failed(error)
    }
    
    @MainActor
    private func updateCategoriesToView(_ categories: [Category]) {
        self.state = .completed(categories)
    }
    
    @MainActor
    private func updateCategories(_ categories: [Category]) {
        self.categories = categories
    }
}
