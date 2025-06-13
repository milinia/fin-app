//
//  TransactionsService.swift
//  fin-app
//
//  Created by Evelina on 10.06.2025.
//

import Foundation

protocol TransactionsServiceProtocol {
    func fetchTransactions(from: Date?, to: Date?) async throws -> [Transaction]
    func createTransaction(accountId: Int, categoryId: Int, amount: Decimal, comment: String) async throws -> Transaction
    func updateTransaction(transactionId: Int, accountId: Int, categoryId: Int, amount: Decimal, comment: String) async throws -> Transaction
    func deleteTransaction(transactionId: Int) async throws -> Bool
}

final class TransactionsService: TransactionsServiceProtocol {
    
    func fetchTransactions(from: Date? = nil, to: Date? = nil) async throws -> [Transaction] {
        [
            Transaction(id: 1,
                        account: BankAccount(id: 1,
                                             name: "Основной счет",
                                             balance: 100000.0,
                                             currency: "RUB"),
                        category: Category(id: 1,
                                           name: "Зарплата",
                                           emoji: "💰",
                                           isIncome: .income),
                        amount: 60000.0,
                        transactionDate: from ?? Date(),
                        createdAt: from ?? Date(),
                        updatedAt: from ?? Date()),
    
            Transaction(id: 1,
                        account: BankAccount(id: 1,
                                             name: "Основной счет",
                                             balance: 10000.0,
                                             currency: "RUB"),
                        category: Category(id: 4,
                                           name: "Квартплата",
                                           emoji: "🏠",
                                           isIncome: .outcome),
                        amount: 5000.0,
                        transactionDate: to ?? Date(),
                        createdAt: to ?? Date(),
                        updatedAt: to ?? Date()),
            
            Transaction(id: 1,
                        account: BankAccount(id: 1,
                                             name: "Основной счет",
                                             balance: 10000.0,
                                             currency: "RUB"),
                        category: Category(id: 6,
                                           name: "Еда",
                                           emoji: "🍔",
                                           isIncome: .outcome),
                        amount: 1000.0,
                        transactionDate: to ?? Date(),
                        createdAt: to ?? Date(),
                        updatedAt: to ?? Date())
        ]
    }
    
    func createTransaction(accountId: Int, categoryId: Int, amount: Decimal, comment: String) async throws -> Transaction {
        Transaction(id: 2,
                    account: BankAccount(id: accountId,
                                         name: "Основной счет",
                                         balance: 10000.0,
                                         currency: "RUB"),
                    category: Category(id: categoryId,
                                       name: "Еда",
                                       emoji: "🍔",
                                       isIncome: .outcome),
                    amount: amount,
                    transactionDate: .now,
                    comment: comment,
                    createdAt: .now,
                    updatedAt: .now)
    }
    
    func updateTransaction(transactionId: Int, accountId: Int, categoryId: Int, amount: Decimal, comment: String) async throws -> Transaction {
        Transaction(id: transactionId,
                    account: BankAccount(id: accountId,
                                         name: "Основной счет",
                                         balance: 10000.0,
                                         currency: "RUB"),
                    category: Category(id: categoryId,
                                       name: "Еда",
                                       emoji: "🍔",
                                       isIncome: .outcome),
                    amount: amount,
                    transactionDate: .now,
                    comment: comment,
                    createdAt: .now,
                    updatedAt: .now)
    }
    
    func deleteTransaction(transactionId: Int) async throws -> Bool {
        true
    }
}
