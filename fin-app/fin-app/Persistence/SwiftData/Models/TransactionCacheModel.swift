//
//  TransactionCacheModel.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation
import SwiftData

@Model
final class TransactionCacheModel: Sendable {
    @Attribute(.unique)
    var id: Int
    @Relationship(deleteRule: .cascade)
    var account: BankAccount
    @Relationship(deleteRule: .cascade)
    var category: CategoryCacheModel
    var amount: String
    var transactionDate: Date
    var currency: String
    var comment: String?
    
    init(
        id: Int,
        account: BankAccount,
        category: CategoryCacheModel,
        amount: String,
        transactionDate: Date,
        currency: String,
        comment: String? = nil
    ) {
        self.id = id
        self.account = account
        self.category = category
        self.amount = amount
        self.transactionDate = transactionDate
        self.currency = currency
        self.comment = comment
    }
}
