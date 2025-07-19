//
//  BankAccountRequest.swift
//  fin-app
//
//  Created by Evelina on 18.07.2025.
//

import Foundation

struct BankAccountRequest: Encodable {
    let name: String
    let balance: String
    let currency: String
}
