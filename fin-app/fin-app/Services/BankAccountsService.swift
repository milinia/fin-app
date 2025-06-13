//
//  BankAccountsService.swift
//  fin-app
//
//  Created by Evelina on 10.06.2025.
//

import Foundation

protocol BankAccountsServiceProtocol {
    func fetchBankAccount() async throws -> BankAccount
    func updateBankAccount(name: String, balance: Decimal, currency: String) async throws -> BankAccount
}

final class BankAccountsService: BankAccountsServiceProtocol {
    
    func fetchBankAccount() async throws -> BankAccount {
        BankAccount(id: 1,
                    name: "Основной счет",
                    balance: 10000.0,
                    currency: "RUB")
    }
    
    func updateBankAccount(name: String, balance: Decimal, currency: String) async throws -> BankAccount {
        BankAccount(id: 1,
                    name: name,
                    balance: balance,
                    currency: currency)
    }
}
