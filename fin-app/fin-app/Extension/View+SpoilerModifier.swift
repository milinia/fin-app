//
//  View+SpoilerModifier.swift
//  fin-app
//
//  Created by Evelina on 27.06.2025.
//

import SwiftUI

extension View {
    func spoiler(isVisible: Binding<Bool>) -> some View {
        self.modifier(SpoilerViewModifier(isSpoilerVisible: isVisible))
    }
}
