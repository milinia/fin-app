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
    
    let transactions = [Transaction(id: 1,
                                   account: BankAccount(id: 1, name: "Основной счет", balance: 100000.0, currency: "RUB"),
                                   category: Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: .income),
                                   amount: 80000.0,
                                   transactionDate: Date(),
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 2,
                                   account: BankAccount(id: 1, name: "Основной счет", balance: 95000.0, currency: "RUB"),
                                   category: Category(id: 2, name: "Кофе", emoji: "☕️", isIncome: .outcome),
                                   amount: 300.0,
                                   transactionDate: Date(),
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 3,
                                   account: BankAccount(id: 1, name: "Основной счет", balance: 93000.0, currency: "RUB"),
                                   category: Category(id: 3, name: "Супермаркет", emoji: "🛒", isIncome: .outcome),
                                   amount: 2000.0,
                                   transactionDate: Date(),
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 4,
                                   account: BankAccount(id: 2, name: "Карта", balance: 50000.0, currency: "RUB"),
                                   category: Category(id: 4, name: "Квартплата", emoji: "🏠", isIncome: .outcome),
                                   amount: 10000.0,
                                   transactionDate: Date(),
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 5,
                                   account: BankAccount(id: 2, name: "Карта", balance: 40000.0, currency: "RUB"),
                                   category: Category(id: 5, name: "Транспорт", emoji: "🚌", isIncome: .outcome),
                                   amount: 700.0,
                                   transactionDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 6,
                                   account: BankAccount(id: 3, name: "Депозит", balance: 300000.0, currency: "RUB"),
                                   category: Category(id: 6, name: "Проценты", emoji: "🏦", isIncome: .income),
                                   amount: 5000.0,
                                   transactionDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 7,
                                   account: BankAccount(id: 1, name: "Основной счет", balance: 92000.0, currency: "RUB"),
                                   category: Category(id: 7, name: "Ресторан", emoji: "🍽️", isIncome: .outcome),
                                   amount: 1500.0,
                                   transactionDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 8,
                                   account: BankAccount(id: 2, name: "Карта", balance: 39000.0, currency: "RUB"),
                                   category: Category(id: 8, name: "Кино", emoji: "🎬", isIncome: .outcome),
                                   amount: 900.0,
                                   transactionDate: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 9,
                                   account: BankAccount(id: 3, name: "Депозит", balance: 305000.0, currency: "RUB"),
                                   category: Category(id: 9, name: "Подарок", emoji: "🎁", isIncome: .income),
                                   amount: 10000.0,
                                   transactionDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                                   createdAt: Date(),
                                   updatedAt: Date()),

                       Transaction(id: 10,
                                   account: BankAccount(id: 1, name: "Основной счет", balance: 91000.0, currency: "RUB"),
                                   category: Category(id: 10, name: "Одежда", emoji: "👕", isIncome: .outcome),
                                   amount: 2500.0,
                                   transactionDate: Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
                                   createdAt: Date(),
                                   updatedAt: Date())]
    
    func fetchTransactions(from: Date? = nil, to: Date? = nil) async throws -> [Transaction] {
        transactions.filter { from ?? .now <= $0.transactionDate && $0.transactionDate <= to ?? .now }
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
