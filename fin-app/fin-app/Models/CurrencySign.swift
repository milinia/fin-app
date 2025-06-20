//
//  CurrencySign.swift
//  fin-app
//
//  Created by Evelina on 17.06.2025.
//

import Foundation

enum CurrencySign: String {
    case usd = "USD"
    case eur = "EUR"
    case rub = "RUB"
    
    var symbol: String {
        switch self {
        case .usd:
            return "$"
        case .eur:
            return "€"
        case .rub:
            return "₽"
        }
    }
}
