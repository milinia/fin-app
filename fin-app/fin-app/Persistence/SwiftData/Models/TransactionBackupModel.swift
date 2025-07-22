//
//  TransactionBackupModel.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation
import SwiftData

enum BackupActionType: String, Codable {
    case create
    case edit
    case delete
}

struct TransactionInfo: Codable {
    let id: Int?
    let accountId: Int?
    let currency: String?
    let categoryId: Int?
    let categoryName: String?
    let categoryEmoji: String?
    let isIncome: Bool?
    let amount: String?
    let transactionDate: Date?
    let comment: String?
}

@Model
final class TransactionBackupModel: Sendable {
    @Attribute(.unique)
    var id = UUID()
    var transaction: TransactionInfo
    var actionType: BackupActionType
    var date: Date
    
    init(transaction: TransactionInfo, actionType: BackupActionType, date: Date) {
        self.transaction = transaction
        self.actionType = actionType
        self.date = date
    }
}
