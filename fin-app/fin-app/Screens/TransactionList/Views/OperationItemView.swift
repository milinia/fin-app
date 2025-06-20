//
//  OperationItemView.swift
//  fin-app
//
//  Created by Evelina on 17.06.2025.
//

import SwiftUI

struct OperationItemView: View {
    
    let operation: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(operation.category.name)
                if let comment = operation.comment {
                    Text(comment)
                        .foregroundColor(Color.lightGray)
                        .font(.system(size: 12))
                }
            }
            
            Spacer()
            
            let amount = String(describing: operation.amount).amountFormatted()
            Text("\(amount) \(CurrencySign(rawValue: operation.account.currency)?.symbol ?? "$")")
            
            Button {
               
            } label: {
                AppIcons.TransactionsListViewIcons.arrowForward.image
                    .frame(width: 16, height: 36)
            }
            .padding(.leading, 16)
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    OperationItemView(operation: Transaction(id: 1,
                                             account: BankAccount(id: 1,
                                                                  name: "Основной счет",
                                                                  balance: 100000.0,
                                                                  currency: "RUB"),
                                             category: Category(id: 1,
                                                                name: "Зарплата",
                                                                emoji: "💰",
                                                                isIncome: .outcome),
                                             amount: 60000.0,
                                             transactionDate: Date(),
                                             comment: "Джек",
                                             createdAt: Date(),
                                             updatedAt: Date()))
}
