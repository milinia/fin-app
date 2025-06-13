//
//  TransactionSerializationTest.swift
//  fin-appTests
//
//  Created by Evelina on 12.06.2025.
//

import XCTest
@testable import fin_app

final class TransactionSerializationTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testEncodeTransactionToValidJSON() throws {
        let transaction = Transaction(id: 1,
                                      account: BankAccount(id: 1, name: "Основной счёт", balance: 1000.0, currency: "RUB"),
                                      category: Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: .income),
                                      amount: 1000.0,
                                      transactionDate: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                      comment: "Зарплата за месяц",
                                      createdAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                      updatedAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!)
        
        let transactionJsonObject: [String: Any] = [
            "id": 1,
            "account": [
                "id": 1,
                "name": "Основной счёт",
                "balance": "1000.00",
                "currency": "RUB"
            ],
            "category": [
                "id": 1,
                "name": "Зарплата",
                "emoji": "💰",
                "isIncome": true
            ],
            "amount": "1000.00",
            "transactionDate": "2025-06-12T09:01:51.359Z",
            "comment": "Зарплата за месяц",
            "createdAt": "2025-06-12T09:01:51.359Z",
            "updatedAt": "2025-06-12T09:01:51.359Z"
        ]
        
        let jsonObject = transaction.jsonObject
        
        XCTAssertEqual(jsonObject as? NSDictionary, transactionJsonObject as NSDictionary)
    }
    
    func testEncodeTransactionWithoutComment() throws {
        let transaction = Transaction(id: 1,
                                      account: BankAccount(id: 1, name: "Основной счёт", balance: 1000.0, currency: "RUB"),
                                      category: Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: .income),
                                      amount: 1000.0,
                                      transactionDate: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                      createdAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                      updatedAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!)
        
        let jsonObject = transaction.jsonObject as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertNil(jsonObject?["comment"])
        
    }
}
