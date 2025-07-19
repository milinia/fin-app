//
//  TransactionsService.swift
//  fin-app
//
//  Created by Evelina on 10.06.2025.
//

import Foundation

protocol TransactionsServiceProtocol {
    func fetchTransactions(from: Date, to: Date, by direction: Direction?) async throws -> [Transaction]
    func createTransaction(transactionInfo: TransactionInfo) async throws -> TransactionDTO?
    func updateTransaction(transactionInfo: TransactionInfo) async throws -> Transaction?
    func deleteTransaction(transactionInfo: TransactionInfo) async throws
}

final class TransactionsService: TransactionsServiceProtocol {
    
    private let userAccountId: Int
    private let networkClient: NetworkClientProtocol
    private let transactionBackupCache: TransactionBackupProtocol
    private let transactionCache: TransactionCacheProtocol
    private let bankAccountsService: BankAccountsServiceProtocol
    
    init(userAccountId: Int, networkClient: NetworkClientProtocol, transactionBackupCache: TransactionBackupProtocol, transactionCache: TransactionCacheProtocol, bankAccountsService: BankAccountsServiceProtocol) {
        self.userAccountId = userAccountId
        self.networkClient = networkClient
        self.transactionBackupCache = transactionBackupCache
        self.transactionCache = transactionCache
        self.bankAccountsService = bankAccountsService
    }
    
    func fetchTransactions(from: Date, to: Date, by direction: Direction? = nil) async throws -> [Transaction] {
        do {
            var transactions: [Transaction] = try await networkClient.request(
                endpoint: TransactionEndpoints.getTransaction(
                    accountId: userAccountId,
                    startDate: from,
                    endDate: to
                )
            )
            if let direction = direction {
                transactions = transactions.filter({ $0.category.isIncome == direction })
            }
            try await saveTransactionsToCache(transactions)
            return transactions
        } catch {
            return try await fetchTransactionsFromCache(direction: direction)
        }
    }
    
    func createTransaction(transactionInfo: TransactionInfo) async throws -> TransactionDTO? {
        let newTransaction = TransactionDTO(
            id: nil,
            accountId: userAccountId,
            categoryId: transactionInfo.categoryId,
            amount: transactionInfo.amount,
            transactionDate: transactionInfo.transactionDate,
            comment: transactionInfo.comment
        )
        
        do {
            let transaction: TransactionDTO = try await networkClient.request(
                with: newTransaction,
                endpoint: TransactionEndpoints.createTransaction(transaction: newTransaction)
            )
            
            let newTransaction = Transaction(
                id: transaction.id ?? 0,
                account: BankAccount(
                    id: transaction.accountId ?? 0,
                    name: "",
                    balance: 0,
                    currency: ""
                ),
                category: Category(
                    id: transaction.categoryId ?? 0,
                    name: transactionInfo.categoryName ?? "",
                    emoji: transactionInfo.categoryEmoji?.first ?? " ",
                    isIncome: transactionInfo.isIncome ?? true ? .income : .outcome),
                amount: Decimal(string: transaction.amount ?? "0") ?? 0,
                transactionDate: transaction.transactionDate ?? Date(),
                comment: transaction.comment
            )
            
            try await transactionCache.addTransaction(newTransaction)
            return transaction
        } catch {
            try await transactionBackupCache.addBackup(for: transactionInfo, action: .create)
            return nil
        }
    }
    
    func updateTransaction(transactionInfo: TransactionInfo) async throws -> Transaction? {
        let updatedTransaction = TransactionDTO(
            id: transactionInfo.id ?? 0,
            accountId: userAccountId,
            categoryId: transactionInfo.categoryId,
            amount: String(describing: transactionInfo.amount),
            transactionDate: transactionInfo.transactionDate,
            comment: transactionInfo.comment
        )
       
        do {
            let transaction: Transaction = try await networkClient.request(
                with: updatedTransaction,
                endpoint: TransactionEndpoints.updateTransaction(
                    id: userAccountId,
                    transaction: updatedTransaction
                )
            )
            
            try await transactionCache.editTransaction(transaction: transaction)
            return transaction
        } catch {
            try await transactionBackupCache.addBackup(for: transactionInfo, action: .edit)
            return nil
        }
                                                                       
    }
    
    func deleteTransaction(transactionInfo: TransactionInfo) async throws {
        do {
            guard let id = transactionInfo.id else { return }
            try await networkClient.request(endpoint: TransactionEndpoints.deleteTransaction(id: id))
            try await transactionCache.deleteTransaction(by: id)
        } catch {
            try await transactionBackupCache.addBackup(for: transactionInfo, action: .delete)
        }
    }
    
    private func saveTransactionsToCache(_ transactions: [Transaction]) async throws {
        try await transactionCache.addTransactions(transactions)
    }
    
    private func fetchTransactionsFromCache(direction: Direction?) async throws -> [Transaction] {
        let transactions = try await transactionCache.getAllTransactions(by: direction)
        var operations = try await transactionBackupCache.getAllBackupOperations()
        
        var dict: [Int: Transaction] = [:]
        for transaction in transactions {
            dict[transaction.id] = transaction
        }
        
        for operation in operations {
            switch operation.actionType {
            case .create:
                let newTransaction = Transaction(
                    id: operation.transaction.id ?? 0,
                    account: BankAccount(
                        id: operation.transaction.accountId ?? 0,
                        name: "",
                        balance: 0,
                        currency: ""
                    ),
                    category: Category(
                        id: operation.transaction.categoryId ?? 0,
                        name: operation.transaction.categoryName ?? "",
                        emoji: operation.transaction.categoryEmoji?.first ?? " ",
                        isIncome: operation.transaction.isIncome ?? true ? .income : .outcome),
                    amount: Decimal(string: operation.transaction.amount ?? "0") ?? 0,
                    transactionDate: operation.transaction.transactionDate ?? Date(),
                    comment: operation.transaction.comment
                )
                
                dict[newTransaction.id] = newTransaction
            case .edit:
                if let id = operation.transaction.id, dict[id] != nil {
                    let newTransaction = Transaction(
                        id: operation.transaction.id ?? 0,
                        account: BankAccount(
                            id: operation.transaction.accountId ?? 0,
                            name: "",
                            balance: 0,
                            currency: ""
                        ),
                        category: Category(
                            id: operation.transaction.categoryId ?? 0,
                            name: operation.transaction.categoryName ?? "",
                            emoji: operation.transaction.categoryEmoji?.first ?? " ",
                            isIncome: operation.transaction.isIncome ?? true ? .income : .outcome),
                        amount: Decimal(string: operation.transaction.amount ?? "0") ?? 0,
                        transactionDate: operation.transaction.transactionDate ?? Date(),
                        comment: operation.transaction.comment
                    )
                    dict[id] = newTransaction
                }
            case .delete:
                if let id = operation.transaction.id, dict[id] != nil {
                    dict[id] = nil
                }
            }
        }
        
        return Array(dict.values)
    }
    
    private func syncOperations() async throws {
        var sychronizedIds = Set<UUID>()
        let operations = try await transactionBackupCache.getAllBackupOperations()
        for operation in operations {
            switch operation.actionType {
            case .create:
                let _ = try await createTransaction(transactionInfo: operation.transaction)
                sychronizedIds.insert(operation.id)
            case .edit:
                let _ = try await updateTransaction(transactionInfo: operation.transaction)
                sychronizedIds.insert(operation.id)
            case .delete:
                try await deleteTransaction(transactionInfo: operation.transaction)
                sychronizedIds.insert(operation.id)
            }
        }
        
        try await deleteSynchronizedOperations(ids: sychronizedIds)
    }
    
    private func deleteSynchronizedOperations(ids: Set<UUID>) async throws {
        for id in ids {
            try await transactionBackupCache.removeBackup(by: id)
        }
    }
}
