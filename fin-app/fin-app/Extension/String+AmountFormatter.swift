//
//  String+AmountFormatter.swift
//  fin-app
//
//  Created by Evelina on 17.06.2025.
//

import Foundation

extension String {
    
    func amountFormatted() -> String {
        let rev = self.reversed()
        var newString = [String]()
        for (index, char) in rev.enumerated() {
            if index % 3 == 0 && index != 0 {
                newString.append(" ")
            }
            newString.append(String(char))
        }
        return newString.reversed().joined()
    }
}
