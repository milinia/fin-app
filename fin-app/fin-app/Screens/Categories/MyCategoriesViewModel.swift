//
//  MyCategoriesViewModel.swift
//  fin-app
//
//  Created by Evelina on 01.07.2025.
//

import Foundation
import SwiftUI
import Fuse

final class MyCategoriesViewModel: ObservableObject {
    
    @Published var categoriesToView: [Category] = []
    private var categories: [Category] = []
    private let categoriesService: CategoriesService
    private let fuse = Fuse()
    
    init(categoriesService: CategoriesService) {
        self.categoriesService = categoriesService
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
    
        let pattern = fuse.createPattern(from: searchText)
        guard let pattern = pattern else {
            return
        }
        
        Task {
            let filteredCategories = categories.filter {
                fuzzySearch(pattern: pattern, in: $0.name)
            }
            await updateCategoriesToView(filteredCategories)
        }
    }
    
    private func fuzzySearch(pattern: Fuse.Pattern, in string: String) -> Bool {
        let searchResult = fuse.search(pattern, in: string)?.ranges
        return (searchResult?.count ?? 0) > 0
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
