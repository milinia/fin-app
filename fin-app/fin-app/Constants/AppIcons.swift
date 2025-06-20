//
//  AppIcons.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import Foundation
import SwiftUI

enum AppIcons {
    
    enum TabBarIcons: String {
        case outcome
        case income
        case balance
        case category
        case settings
        
        var image: Image {
            Image(rawValue)
        }
    }
    
    enum TransactionsListViewIcons: String {
        case arrowForward
        case clocks
        
        var image: Image {
            Image(rawValue)
        }
    }
    
    enum HistoryViewIcons: String {
        case file
        case backPurple
        
        var image: Image {
            Image(rawValue)
        }
    }
    
}
