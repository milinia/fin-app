//
//  Transaction.swift
//  fin-app
//
//  Created by Evelina on 07.06.2025.
//

import Foundation

struct Transaction: Codable, Equatable, Identifiable {
    let id: Int
    let account: BankAccount
    let category: Category
    let amount: Decimal
    let transactionDate: Date
    let comment: String?
    
    init (id: Int, account: BankAccount, category: Category, amount: Decimal, transactionDate: Date, comment: String? = nil) {
        self.id = id
        self.account = account
        self.category = category
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case account
        case category
        case amount
        case transactionDate
        case comment
        case createdAt
        case updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.account = try container.decode(BankAccount.self, forKey: .account)
        self.category = try container.decode(Category.self, forKey: .category)
        
        let amountString = try container.decode(String.self, forKey: .amount)
        guard let amount = Decimal(string: amountString) else {
            throw DecodingError.dataCorruptedError(forKey: .amount, in: container, debugDescription: "Invalid amount format")
        }
        self.amount = amount
        
        guard let transactionDate = try Transaction.decodeDate(key: .transactionDate, container: container) else {
            throw DecodingError.dataCorruptedError(forKey: .transactionDate, in: container, debugDescription: "Invalid date format")
        }
        self.transactionDate = transactionDate
        
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.account, forKey: .account)
        try container.encode(self.category, forKey: .category)
        
        let formattedAmount = String(format: "%.2f", (self.amount as NSDecimalNumber).doubleValue)
        try container.encode(formattedAmount, forKey: .amount)
        
        try container.encode(self.transactionDate, forKey: .transactionDate)
        try container.encodeIfPresent(self.comment, forKey: .comment)
    }
}

extension Transaction {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()
    
    private static func decodeDate(key: KeyedDecodingContainer<CodingKeys>.Key,
                            container: KeyedDecodingContainer<CodingKeys>) throws -> Date? {
        let dateString = try container.decode(String.self, forKey: key)
        return dateFormatter.date(from: dateString)
    }
}

extension Transaction {
    
    var jsonObject: Any {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(Transaction.dateFormatter)
            let jsonData = try encoder.encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: [])
        } catch {
            return [:]
        }
    }
    
    static func parse(jsonObject: Any) -> Transaction? {
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            return nil
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return try JSONDecoder().decode(Transaction.self, from: jsonData)
        } catch {
            return nil
        }
    }
}

extension Transaction {
    
    // можно было через joined на массив
    var csvObject: String {
        let bankAccountString = "\(account.id),\(account.name),\(account.balance),\(account.currency)"
        let categoryString = "\(category.id),\(category.name),\(category.emoji),\(category.isIncome == .income)"
        let transactionDateString = Transaction.dateFormatter.string(from: transactionDate)
        return "\(id),\(bankAccountString),\(categoryString),\(amount),\(transactionDateString),\(comment ?? "")"
    }
    
    static func parse(csvString: String) -> Transaction? {
        let components = csvString.components(separatedBy: ",")
        
        guard let bankAccountId = Int(components[1]), let balance = Decimal(string: components[3]) else {
            return nil
        }
        
        let bankAccount = BankAccount(id: bankAccountId, name: components[2], balance: balance, currency: components[4])
        
        guard let categoryId = Int(components[5]), let isIncome = Bool(String(components[8])) else {
            return nil
        }
        
        let category = Category(id: categoryId, name: components[6], emoji: Character(components[7]), isIncome: isIncome ? .income : .outcome)
        
        guard let id = Int(components[0]), let amount = Decimal(string: components[9]), let transactionDate = Transaction.dateFormatter.date(from: components[10])
        else {
            return nil
        }
        
        return Transaction(id: id,
                           account: bankAccount,
                           category: category,
                           amount: amount,
                           transactionDate: transactionDate,
                           comment: components[11])
    }
}
