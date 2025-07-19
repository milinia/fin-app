//
//  BankAccountBackupModel.swift
//  fin-app
//
//  Created by Evelina on 19.07.2025.
//

import Foundation
import SwiftData

@Model
final class BankAccountBackupModel: Sendable {
    var id: UUID = UUID()
    var name: String
    var balance: String
    var currency: String
    
    init(name: String, balance: String, currency: String) {
        self.name = name
        self.balance = balance
        self.currency = currency
    }
}
