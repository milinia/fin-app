//
//  TransactionBackupCache.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation
import SwiftData

protocol TransactionBackupProtocol {
    func getAllBackupOperations() async throws -> [TransactionBackupModel]
    func addBackup(for transaction: TransactionInfo, action: BackupActionType) async throws
    func removeBackup(by id: UUID) async throws
}

actor TransactionBackupCache: ModelActor, TransactionBackupProtocol {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    private var modelContext: ModelContext {
        modelExecutor.modelContext
    }
    
    private func fetchTransaction(by id: UUID) throws -> TransactionBackupModel? {
        var descriptor = FetchDescriptor<TransactionBackupModel>(
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
    
    func getAllBackupOperations() async throws -> [TransactionBackupModel] {
        let backupTransactionDescriptor = FetchDescriptor<TransactionBackupModel>(
            predicate: nil,
            sortBy: [.init(\.date)]
        )
        
        return try modelContext.fetch(backupTransactionDescriptor)
    }
    
    func addBackup(for transaction: TransactionInfo, action: BackupActionType) async throws {
        let backupTransaction = TransactionBackupModel(
            transaction: transaction,
            actionType: action,
            date: Date()
        )
        
        modelContext.insert(backupTransaction)
        try modelContext.save()
    }
    
    func removeBackup(by id: UUID) async throws {
        guard let backupTransaction = try fetchTransaction(by: id) else {
            return
        }
        
        modelContext.delete(backupTransaction)
        try modelContext.save()
    }
}
