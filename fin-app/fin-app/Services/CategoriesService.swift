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
    
    //можно было бы вынести в отдельную переменную и потом делать filter по типу в fetchCategories(by: Direction)
    func fetchAllCategories() async throws -> [Category] {
        [
            Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: .income),
            Category(id: 2, name: "Подарок", emoji: "🎁", isIncome: .income),
            Category(id: 3, name: "Проценты по вкладам", emoji: "📈", isIncome: .income),
            Category(id: 4, name: "Квартплата", emoji: "🏠", isIncome: .outcome),
            Category(id: 5, name: "Общественный транспорт", emoji: "🚌", isIncome: .outcome),
            Category(id: 6, name: "Еда", emoji: "🍔", isIncome: .outcome)
        ]
    }
    
    func fetchCategories(by: Direction) async throws -> [Category] {
        if by == .income {
            [
                Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: .income),
                Category(id: 2, name: "Подарок", emoji: "🎁", isIncome: .income),
                Category(id: 3, name: "Проценты по вкладам", emoji: "📈", isIncome: .income)
            ]
        } else {
            [
                Category(id: 4, name: "Квартплата", emoji: "🏠", isIncome: .outcome),
                Category(id: 5, name: "Общественный транспорт", emoji: "🚌", isIncome: .outcome),
                Category(id: 6, name: "Еда", emoji: "🍔", isIncome: .outcome)
            ]
        }
    }
}
