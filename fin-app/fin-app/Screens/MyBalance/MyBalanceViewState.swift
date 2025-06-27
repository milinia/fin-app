//
//  MyBalanceViewState.swift
//  fin-app
//
//  Created by Evelina on 24.06.2025.
//

import Foundation
import SwiftUI

enum MyBalanceViewState {
    case view
    case edit

    var leadingNavigationButtonTitle: String {
        switch self {
        case .view:
            return Strings.MyBalanceView.edit
        case .edit:
            return Strings.MyBalanceView.save
        }
    }
    
    var balanceTextBackgroundColor: Color {
        switch self {
        case .view:
            return .accent
        case .edit:
            return Color(UIColor.systemBackground)
        }
    }
    
    var currencyTextColor: Color {
        switch self {
        case .view:
            return .lightGreen
        case .edit:
            return Color(UIColor.systemBackground)
        }
    }
}
