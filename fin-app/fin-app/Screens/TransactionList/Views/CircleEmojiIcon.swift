//
//  CircleEmojiIcon.swift
//  fin-app
//
//  Created by Evelina on 18.06.2025.
//

import SwiftUI

struct CircleEmojiIcon: View {
    let emoji: String
        
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.lightGreen)
                .frame(width: 22, height: 22)
            Text(emoji)
                .font(.system(size: 13))
        }
    }
}

#Preview {
    CircleEmojiIcon(emoji: "💻")
}
