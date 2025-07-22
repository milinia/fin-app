//
//  ManageTransactionScreenState.swift
//  fin-app
//
//  Created by Evelina on 11.07.2025.
//

import Foundation
import SwiftUI

enum ManageTransactionScreenState {
    case create(Direction)
    case edit(Direction, Transaction)
    
    var isDeleteButtonEnabled: Bool {
        switch self {
        case .edit:
            return true
        case .create:
            return false
        }
    }
    
    var rightBarButtonTitle: String {
        switch self {
        case .edit:
            return "Сохранить"
        case .create:
            return "Создать"
        }
    }
    
    var title: String {
        switch self {
        case .edit(let direction, _):
            return direction == .income ? "Мои Доходы" : "Мои Расходы"
        case .create(let direction):
            return direction == .income ? "Мои Доходы" : "Мои Расходы"
        }
    }
    
    var categoryPlaceholder: String {
        switch self {
        case .edit(_, let transaction):
            return transaction.category.name
        case .create:
            return " "
        }
    }
    
    var amountPlaceholder: String {
        switch self {
        case .edit(_, let transaction):
            return String(describing: transaction.amount)
        case .create:
            return ""
        }
    }
    
    var commentPlaceholder: String {
        switch self {
        case .edit:
            return ""
        case .create:
            return "Комментарий"
        }
    }
    
    var commentColor: Color {
        switch self {
        case .edit(_, let transaction):
            return transaction.comment == nil ? .gray : .black
        case .create:
            return .gray
        }
    }
    
    var date: Date {
        switch self {
            case .edit(_, let transaction):
            return transaction.transactionDate
        case .create:
            return Date()
        }
    }
    
    var direction: Direction {
        switch self {
        case .edit(let direction, _):
            return direction
        case .create(let direction):
            return direction
        }
    }
    
    var selectedCategory: Category? {
        switch self {
        case .edit(_, let transaction):
            return transaction.category
        case .create:
            return nil
        }
    }
    
    var initialComment: String {
        switch self {
        case .edit(_, let transaction):
            return transaction.comment ?? ""
        case .create:
            return ""
        }
    }
    
    var deleteButtonTitle: String {
        switch self {
        case .edit(let direction, _):
            return direction == .income ? Strings.ManageTransactionView.deleteIncome : Strings.ManageTransactionView.deleteOutcome
        case .create:
            return " "
        }
    }
    
    var transaction: Transaction? {
        switch self {
            case .edit(_, let transaction):
            return transaction
        case .create:
            return nil
        }
    }
}
