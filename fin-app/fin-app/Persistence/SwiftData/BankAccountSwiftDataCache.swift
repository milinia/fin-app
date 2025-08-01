//
//  BankAccountSwiftDataCache.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation
import SwiftData

protocol BankAccountCacheProtocol {
    func getAccount() async throws -> BankAccount?
    func editAccount(id: Int, newAmount: Decimal, newCurrency: String, newName: String) async throws
}

actor BankAccountSwiftDataCache: ModelActor, BankAccountCacheProtocol {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    private var modelContext: ModelContext {
        modelExecutor.modelContext
    }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelExecutor = DefaultSerialModelExecutor(
            modelContext: ModelContext(modelContainer)
        )
    }
    
    func getAccount() async throws -> BankAccount? {
        var accountDescriptor = FetchDescriptor<BankAccount>(predicate: nil)
        accountDescriptor.fetchLimit = 1
        return try modelContext.fetch(accountDescriptor).first
    }
    
    func editAccount(id: Int, newAmount: Decimal, newCurrency: String, newName: String) async throws {
        var accountDescriptor = FetchDescriptor<BankAccount>(
            predicate: #Predicate<BankAccount> { $0.id == id }
        )
        accountDescriptor.fetchLimit = 1
        
        if let existingAccount = try modelContext.fetch(accountDescriptor).first {
            existingAccount.name = newName
            existingAccount.currency = newCurrency
            existingAccount.balance = newAmount
        } else {
            let account = BankAccount(id: id, name: newName, balance: newAmount, currency: newCurrency)
            modelContext.insert(account)
        }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
}
