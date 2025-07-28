//
//  BankAccountsService.swift
//  fin-app
//
//  Created by Evelina on 10.06.2025.
//

import Foundation

protocol BankAccountsServiceProtocol {
    func fetchBankAccount() async throws -> BankAccount?
    func updateBankAccount(balance: Decimal, currency: String) async throws -> BankAccount?
}

final class BankAccountsService: BankAccountsServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    private var account: BankAccount?
    private let bankAccountCache: BankAccountCacheProtocol
    
    init(networkClient: NetworkClientProtocol, bankAccountCache: BankAccountCacheProtocol) {
        self.networkClient = networkClient
        self.bankAccountCache = bankAccountCache
    }
    
    func fetchBankAccount() async throws -> BankAccount? {
        do {
            if let cachedAccount = try await bankAccountCache.getAccount() {
                let _: BankAccount = try await networkClient.request(
                    with: cachedAccount,
                    endpoint: AccountEndpoints.updateAccount(
                        id: cachedAccount.id,
                        account: BankAccountRequest(
                            name: cachedAccount.name,
                            balance: String(describing: cachedAccount.balance),
                            currency: cachedAccount.currency)
                    )
                )
                await saveAccount(cachedAccount)
                return cachedAccount
            } else {
                let accounts: [BankAccount] = try await networkClient.request(
                    endpoint: AccountEndpoints.getAccounts
                )
                guard let account = accounts.first else {
                    return nil
                }
                try await bankAccountCache.editAccount(
                    id: account.id,
                    newAmount: account.balance,
                    newCurrency: account.currency,
                    newName: account.name
                )
                await saveAccount(account)
                return account
            }
        } catch {
            if let cachedAccount = try await bankAccountCache.getAccount() {
               return cachedAccount
            }
        }
        
        return nil
    }
    
    @MainActor
    private func saveAccount(_ account: BankAccount) {
        self.account = account
    }
    
    func updateBankAccount(balance: Decimal, currency: String) async throws -> BankAccount? {
        guard let account = self.account else {
            return nil
        }
        
        if account.balance == balance && account.currency == currency {
            return account
        }

        let newBankAccount = BankAccountRequest(
            name: account.name,
            balance: String(describing: balance),
            currency: currency
        )
        
        do {
            let bankAccountResponse: BankAccount = try await networkClient.request(
                with: newBankAccount,
                endpoint: AccountEndpoints.updateAccount(
                    id: account.id,
                    account: newBankAccount)
            )
            
            try await bankAccountCache.editAccount(
                id: account.id,
                newAmount: account.balance,
                newCurrency: account.currency,
                newName: account.name
            )
            
            return bankAccountResponse
        } catch {
            try await bankAccountCache.editAccount(
                id: account.id,
                newAmount: account.balance,
                newCurrency: account.currency,
                newName: account.name
            )
            return nil
        }
    }
}
