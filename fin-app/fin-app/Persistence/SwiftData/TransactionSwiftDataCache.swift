//
//  TransactionSwiftDataCache.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation
import SwiftData

protocol TransactionCacheProtocol {
    func getAllTransactions(by direction: Direction?) async throws -> [Transaction]
    func editTransaction(transaction: Transaction) async throws
    func deleteTransaction(by id: Int) async throws
    func addTransaction(_ transaction: Transaction) async throws
    func addTransactions(_ transactions: [Transaction]) async throws
}

actor TransactionSwiftDataCache: ModelActor, TransactionCacheProtocol {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    private var modelContext: ModelContext {
        modelExecutor.modelContext
    }
    
    private func fetchTransaction(by id: Int) throws -> TransactionCacheModel? {
        var descriptor = FetchDescriptor<TransactionCacheModel>(
            predicate: #Predicate { $0.id == id },
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelExecutor = DefaultSerialModelExecutor(
            modelContext: ModelContext(modelContainer)
        )
    }
    
    func getAllTransactions(by direction: Direction? = nil) async throws -> [Transaction] {
        let predicate: Predicate<TransactionCacheModel>? = {
            guard let direction = direction else { return nil }
            let bool: Bool = (direction == Direction.income)
            return #Predicate {
                $0.category.isIncome == bool
            }
        }()
        
        let transactionDescriptor = FetchDescriptor<TransactionCacheModel>(
            predicate: predicate,
            sortBy: [.init(\.transactionDate)]
        )
        
        let transactions = try modelContext.fetch(transactionDescriptor)
        
        return transactions.map { transaction in
            Transaction(id: transaction.id,
                        account: transaction.account,
                        category: Category(
                            id: transaction.category.id,
                            name: transaction.category.name,
                            emoji: transaction.category.emoji.first ?? " ",
                            isIncome: transaction.category.isIncome ? .income : .outcome
                        ),
                        amount: Decimal(string: transaction.amount) ?? 0,
                        transactionDate: transaction.transactionDate,
                        comment: transaction.comment
            )
        }
    }
    
    func editTransaction(transaction: Transaction) async throws {
        guard let existingTransaction = try fetchTransaction(by: transaction.id) else {
            return
        }
        
        updateParameters(existingTransaction: existingTransaction, transaction: transaction)
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func deleteTransaction(by id: Int) async throws {
        guard let transactionToDelete = try fetchTransaction(by: id) else { return }
        modelContext.delete(transactionToDelete)
        try modelContext.save()
    }
    
    func addTransaction(_ transaction: Transaction) async throws {
        try await addOrUpdateTransaction(transaction)
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func addTransactions(_ transactions: [Transaction]) async throws {
        for transaction in transactions {
            try await addOrUpdateTransaction(transaction)
        }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    private func addOrUpdateTransaction(_ transaction: Transaction) async throws {
        if let existingTransaction = try fetchTransaction(by: transaction.id) {
            updateParameters(existingTransaction: existingTransaction, transaction: transaction)
        } else {
            let categoryModel = try fetchOrCreateCategory(from: transaction.category)
            let accountModel = try fetchOrCreateBankAccount(by: transaction.account)
            
            let newTransactionCacheModel = TransactionCacheModel(
                id: transaction.id,
                account: accountModel,
                category: categoryModel,
                amount: String(describing: transaction.amount),
                transactionDate: transaction.transactionDate,
                currency: transaction.account.currency,
                comment: transaction.comment
            )
            modelContext.insert(newTransactionCacheModel)
        }
    }
    
    func fetchOrCreateCategory(from category: Category) throws -> CategoryCacheModel {
        let descriptor = FetchDescriptor<CategoryCacheModel>(
            predicate: #Predicate { $0.id == category.id }
        )
        
        if let existing = try modelContext.fetch(descriptor).first {
            return existing
        } else {
            let newCategory = CategoryCacheModel(
                id: category.id,
                name: category.name,
                emoji: String(category.emoji),
                isIncome: category.isIncome == .income
            )
            modelContext.insert(newCategory)
            return newCategory
        }
    }
    
    func fetchOrCreateBankAccount(by account: BankAccount) throws -> BankAccount {
        let descriptor = FetchDescriptor<BankAccount>(
            predicate: #Predicate { $0.id == account.id }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            return existing
        } else {
            let newAccount = BankAccount(
                id: account.id,
                name: account.name,
                balance: account.balance,
                currency: account.currency
            )
            modelContext.insert(newAccount)
            return newAccount
        }
    }
    
    private func updateParameters(existingTransaction: TransactionCacheModel, transaction: Transaction) {
        do {
            let updatedCategory = try fetchOrCreateCategory(from: transaction.category)
            existingTransaction.category = updatedCategory
        } catch {
            print("Failed to fetch/create category: \(error)")
        }
        
        existingTransaction.amount = String(describing: transaction.amount)
        existingTransaction.transactionDate = transaction.transactionDate
        existingTransaction.currency = transaction.account.currency
        existingTransaction.comment = transaction.comment
    }
}
