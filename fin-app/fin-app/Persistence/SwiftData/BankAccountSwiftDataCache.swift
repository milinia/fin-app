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
        var categoryDescriptor = FetchDescriptor<BankAccount>(predicate: nil)
        categoryDescriptor.fetchLimit = 1
        return try modelContext.fetch(categoryDescriptor).first
    }
    
    func editAccount(id: Int, newAmount: Decimal, newCurrency: String, newName: String) async throws {
        var categoryDescriptor = FetchDescriptor<BankAccount>(
            predicate: #Predicate<BankAccount> { $0.id == id }
        )
        categoryDescriptor.fetchLimit = 1
        
        guard let account = try modelContext.fetch(categoryDescriptor).first else {
            let account = BankAccount(id: id, name: newName, balance: newAmount, currency: newCurrency)
            
            modelContext.insert(account)
            if modelContext.hasChanges {
                try modelContext.save()
            }
            
            return
        }
        account.name = newName
        account.currency = newCurrency
        account.balance = newAmount
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
}
