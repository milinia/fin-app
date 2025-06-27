//
//  MyBalanceModel.swift
//  fin-app
//
//  Created by Evelina on 24.06.2025.
//

import Foundation

final class MyBalanceModel: ObservableObject {
    
    @Published var bankAccount: BankAccount?
    @Published var selectedCurrency: CurrencySign = .rub
    @Published var balance: Decimal = 0
    @Published var balanceString: String = ""
    
    private let bankAccountService: BankAccountsServiceProtocol
    
    init(bankAccountService: BankAccountsServiceProtocol) {
        self.bankAccountService = bankAccountService
    }
    
    func fetchBankAccount() {
        Task {
            do {
                let account = try await bankAccountService.fetchBankAccount()
                await setBankAccount(account)
            }
        }
    }
    
    @MainActor
    private func setBankAccount(_ account: BankAccount) {
        bankAccount = account
        
        let currency = bankAccount?.currency ?? ""
        let currencySign = CurrencySign(rawValue: currency) ?? .usd
        selectedCurrency = currencySign
        
        self.balance = account.balance
        let balanceString = String(describing: balance)
        let balanceFormatted = balanceString.amountFormatted()
        self.balanceString = balanceFormatted
    }
    
    func updateBankAccount() {
        Task{
            do {
                let newAccount = try await bankAccountService.updateBankAccount(balance: balance,
                                                                                currency: selectedCurrency.rawValue)
                await setBankAccount(newAccount)
            }
        }
    }
    
    func updateBalance(_ newBalance: String) {
        balance = Decimal(string: newBalance) ?? 0
        balanceString = newBalance.amountFormatted()
    }
}
