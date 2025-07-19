//
//  ErrorView.swift
//  fin-app
//
//  Created by Evelina on 16.07.2025.
//

import SwiftUI

struct ErrorView: View {
    
    private var message: String
    private var action: () -> Void
    
    init(message: String, action: @escaping () -> Void) {
        self.message = message
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Упс!")
                .font(.headline)
            Text(message)
            Button {
                action()
            } label: {
                Text("Обновить")
                    .padding()
            }
            .background(Color.lightGreen)
            .cornerRadius(8)
        }
        .padding()
    }
}
