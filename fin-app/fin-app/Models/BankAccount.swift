//
//  BankAccount.swift
//  fin-app
//
//  Created by Evelina on 07.06.2025.
//

import Foundation
import SwiftData

@Model
final class BankAccount: Codable, Equatable, Sendable {
    @Attribute(.unique)
    var id: Int
    var name: String
    var balance: Decimal
    var currency: String
    
    init (id: Int, name: String, balance: Decimal, currency: String) {
        self.id = id
        self.name = name
        self.balance = balance
        self.currency = currency
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case balance
        case currency
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        let stringBalance = try container.decode(String.self, forKey: .balance)
        guard let balanceValue = Decimal(string: stringBalance) else {
            throw DecodingError.dataCorruptedError(forKey: .balance, in: container, debugDescription: "Invalid balance format")
        }
        self.balance = balanceValue
        
        self.currency = try container.decode(String.self, forKey: .currency)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        let formattedBalance = String(format: "%.2f", (balance as NSDecimalNumber).doubleValue)
        try container.encode(formattedBalance, forKey: .balance)
        
        try container.encode(currency, forKey: .currency)
    }
}
