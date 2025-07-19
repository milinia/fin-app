//
//  TransactionDTO.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation

struct TransactionDTO: Codable {
    let id: Int?
    let accountId: Int?
    let categoryId: Int?
    let amount: String?
    let transactionDate: Date?
    let comment: String?
}
