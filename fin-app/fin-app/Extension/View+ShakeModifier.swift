//
//  View+ShakeModifier.swift
//  fin-app
//
//  Created by Evelina on 26.06.2025.
//

import Foundation
import SwiftUI

extension View {
    func onShake(_ action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
