//
//  MyBalanceModel.swift
//  fin-app
//
//  Created by Evelina on 24.06.2025.
//

import Foundation

final class MyBalanceModel: LoadableObject {
    typealias DataType = BankAccount
    
    @Published var state: LoadingState<BankAccount>
    @Published var selectedCurrency: CurrencySign = .rub
    @Published var balance: Decimal = 0
    @Published var balanceString: String = ""
    
    private let bankAccountService: BankAccountsServiceProtocol
    
    init(bankAccountService: BankAccountsServiceProtocol) {
        self.bankAccountService = bankAccountService
        state = .loading
    }
    
    func fetchBankAccount() async {
        do {
            let account = try await bankAccountService.fetchBankAccount()
            guard let account = account else {
                throw NetworkError.requestError
            }
            await setBankAccount(account)
        } catch {
            await setError(error)
        }
    }
    
    @MainActor
    private func setError(_ error: Error) {
        state = .failed(error)
    }
    
    @MainActor
    private func setBankAccount(_ account: BankAccount) {
        state = .completed(account)
        
        let currency = account.currency
        let currencySign = CurrencySign(rawValue: currency) ?? .usd
        selectedCurrency = currencySign
        
        self.balance = account.balance
        let balanceString = String(describing: balance)
        let balanceFormatted = balanceString.amountFormatted()
        self.balanceString = balanceFormatted
    }
    
    func updateBankAccount() {
        Task {
            do {
                guard let newAccount = try await bankAccountService.updateBankAccount(balance: balance,
                                                                                currency: selectedCurrency.rawValue)
                else {
                    return
                }
                await setBankAccount(newAccount)
            }
        }
    }
    
    func updateBalance(_ newBalance: String) {
        balance = Decimal(string: newBalance) ?? 0
        balanceString = newBalance.amountFormatted()
    }
}
