//
//  SpoilerViewModifier.swift
//  fin-app
//
//  Created by Evelina on 26.06.2025.
//

import SwiftUI

struct SpoilerViewModifier: ViewModifier {
    
    @Binding var isSpoilerVisible: Bool
    
    func body(content: Content) -> some View {
        content.overlay {
            SpoilerView(isSpoilerVisible: isSpoilerVisible)
                .allowsHitTesting(false)
        }
    }
    
}
