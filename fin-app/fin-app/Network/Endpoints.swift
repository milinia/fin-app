//
//  Endpoints.swift
//  fin-app
//
//  Created by Evelina on 15.07.2025.
//

import Foundation

protocol EndpointProtocol {
    var path: String { get }
    var method: String { get }
    var hasBody: Bool { get }
    var hasResponseBody: Bool { get }
}

extension EndpointProtocol {
    var host: String {
        "https://shmr-finance.ru/api/v1"
    }
}

enum AccountEndpoints: EndpointProtocol {
    case getAccounts
    case updateAccount(id: Int, account: BankAccountRequest)
    
    var path: String {
        switch self {
            case .getAccounts:
                return "/accounts"
            case .updateAccount(let id, _):
                return "/accounts/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .getAccounts:
            return "GET"
        case .updateAccount:
            return "PUT"
        }
    }
    
    var hasBody: Bool {
        switch self {
        case .getAccounts:
            return false
        case .updateAccount:
            return true
        }
    }
    
    var hasResponseBody: Bool {
        true
    }
}

enum TransactionEndpoints: EndpointProtocol {
    case createTransaction(transaction: TransactionDTO)
    case deleteTransaction(id: Int)
    case updateTransaction(id: Int, transaction: TransactionDTO)
    case getTransaction(accountId: Int, startDate: Date, endDate: Date)
    
    var path: String {
        switch self {
        case .createTransaction:
            return "/transactions"
        case .deleteTransaction(let id):
            return "/transactions/\(id)"
        case .updateTransaction(let id, _):
            return "/transactions/\(id)"
        case .getTransaction(let accountId, _, _):
            return "/transactions/account/\(accountId)/period"
        }
    }
    
    var method: String {
        switch self {
        case .createTransaction:
            return "POST"
        case .updateTransaction:
            return "PUT"
        case .deleteTransaction:
            return "DELETE"
        case .getTransaction:
            return "GET"
        }
    }
    
    var hasBody: Bool {
        switch self {
        case .createTransaction, .updateTransaction:
            return true
        case .deleteTransaction, .getTransaction:
            return false
        }
    }
    
    var hasResponseBody: Bool {
        switch self {
        case .createTransaction, .updateTransaction, .getTransaction:
            return true
        case .deleteTransaction:
            return false
        }
    }
}

enum CategoriesEndpoints: EndpointProtocol {
    case getCategories
    case getCategoriesBy(direction: Direction)
    
    var path: String {
        switch self {
        case .getCategories:
            return "/categories"
        case .getCategoriesBy(let direction):
            let directionString: String = direction == .income ? "true" : "false"
            return "/categories/type/\(directionString)"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var hasBody: Bool {
        return false
    }
    
    var hasResponseBody: Bool {
        return true
    }
}
