//
//  CurrencySign.swift
//  fin-app
//
//  Created by Evelina on 17.06.2025.
//

import Foundation

enum CurrencySign: String, CaseIterable {
    case rub = "RUB"
    case usd = "USD"
    case eur = "EUR"
    
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
    
    var text: String {
        switch self {
        case .usd:
            return "Американский доллар"
        case .eur:
            return "Евро"
        case .rub:
            return "Российский рубль"
        }
    }
}
