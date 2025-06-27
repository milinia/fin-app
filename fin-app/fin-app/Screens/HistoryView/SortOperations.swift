//
//  SortOperations.swift
//  fin-app
//
//  Created by Evelina on 19.06.2025.
//

import Foundation

enum SortBy {
    case byDate
    case byAmount
    
    var title: String {
        switch self {
        case .byDate:
            return Strings.HistoryView.byDate
        case .byAmount:
            return Strings.HistoryView.byAmount
        }
    }
}
