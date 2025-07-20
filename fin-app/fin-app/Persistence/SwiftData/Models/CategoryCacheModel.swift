//
//  CategoryCacheModel.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation
import SwiftData

@Model
final class CategoryCacheModel: Sendable {
    @Attribute(.unique)
    var id: Int
    var name: String
    var emoji: String
    var isIncome: Bool

    init(
        id: Int,
        name: String,
        emoji: String,
        isIncome: Bool
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isIncome = isIncome
    }
}

extension CategoryCacheModel {
    convenience init(from category: Category) {
        self.init(
            id: category.id,
            name: category.name,
            emoji: String(category.emoji),
            isIncome: category.isIncome == .income
        )
    }
}
