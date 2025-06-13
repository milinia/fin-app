//
//  TransactionDeserializationTest.swift
//  fin-appTests
//
//  Created by Evelina on 11.06.2025.
//

import XCTest
@testable import fin_app

final class TransactionDeserializationTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testDecodeTransactionFromValidJSON() throws {
        let jsonObject: [String: Any] = [
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
            "amount": "500.00",
            "transactionDate": "2025-06-12T09:01:51.359Z",
            "comment": "Зарплата за месяц",
            "createdAt": "2025-06-12T09:01:51.359Z",
            "updatedAt": "2025-06-12T09:01:51.359Z"
        ]
        
        let transactionValue = Transaction(id: 1,
                                           account: BankAccount(id: 1, name: "Основной счёт", balance: 1000.0, currency: "RUB"),
                                           category: Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: .income),
                                           amount: 500.0,
                                           transactionDate: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                           comment: "Зарплата за месяц",
                                           createdAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                           updatedAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!)
        
        let transaction = Transaction.parse(jsonObject: jsonObject)
        
        XCTAssertEqual(transaction, transactionValue)
    }
    
    func testDecodeTransactionWithOptionalValueMissing() throws {
        let jsonObject: [String: Any] = [
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
            "amount": "500.00",
            "transactionDate": "2025-06-12T09:01:51.359Z",
            "createdAt": "2025-06-12T09:01:51.359Z",
            "updatedAt": "2025-06-12T09:01:51.359Z"
        ]
        
        let transactionValue = Transaction(id: 1,
                                           account: BankAccount(id: 1, name: "Основной счёт", balance: 1000.0, currency: "RUB"),
                                           category: Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: .income),
                                           amount: 500.0,
                                           transactionDate: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                           createdAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!,
                                           updatedAt: Transaction.dateFormatter.date(from: "2025-06-12T09:01:51.359Z")!)
        
        let transaction = Transaction.parse(jsonObject: jsonObject)
        
        XCTAssertEqual(transaction, transactionValue)
    }
       
    func testDecodeTransactionFailsWithInvalidJSON() throws {
        let jsonObject: [AnyHashable: Any] = [
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
            "amount": "500.00",
            "transactionDate": "2025-06-12T09:01:51.359Z",
            "comment": "Зарплата за месяц",
            1: "2025-06-12T09:01:51.359Z",
            "updatedAt": "2025-06-12T09:01:51.359Z"
        ]
        
        let transaction = Transaction.parse(jsonObject: jsonObject)
        
        XCTAssertNil(transaction)
    }
    
    func testDecodeTransactionFailsWithInvalidEmojiCharacter() throws {
        let jsonObject: [String: Any] = [
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
                "emoji": "💰💰",
                "isIncome": true
            ],
            "amount": "500.00",
            "transactionDate": "2025-06-12T09:01:51.359Z",
            "comment": "Зарплата за месяц",
            "createdAt": "2025-06-12T09:01:51.359Z",
            "updatedAt": "2025-06-12T09:01:51.359Z"
        ]
        
        let transaction = Transaction.parse(jsonObject: jsonObject)
        
        XCTAssertNil(transaction)
    }
    
    func testDecodeTransactionFailsWithInvalidCategoryIsIncomeValue() throws {
        let jsonObject: [String: Any] = [
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
                "isIncome": 3
            ],
            "amount": "500.00",
            "transactionDate": "2025-06-12T09:01:51.359Z",
            "comment": "Зарплата за месяц",
            "createdAt": "2025-06-12T09:01:51.359Z",
            "updatedAt": "2025-06-12T09:01:51.359Z"
        ]
        
        let transaction = Transaction.parse(jsonObject: jsonObject)
        
        XCTAssertNil(transaction)
    }
    
    func testDecodeTransactionFailsWithMissingParameters() throws {
        let jsonObject: [String: Any] = [
            "id": 1,
            "account": [
                "id": 1,
                "name": "Основной счёт",
                "balance": "1000.00",
                "currency": "RUB"
            ],
            "amount": "500.00",
            "transactionDate": "2025-06-12T09:01:51.359Z",
            "comment": "Зарплата за месяц",
            "createdAt": "2025-06-12T09:01:51.359Z",
            "updatedAt": "2025-06-12T09:01:51.359Z"
        ]
        
        let transaction = Transaction.parse(jsonObject: jsonObject)
        
        XCTAssertNil(transaction)
    }
}
