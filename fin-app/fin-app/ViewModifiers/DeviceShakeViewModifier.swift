//
//  DeviceShakeViewModifier.swift
//  fin-app
//
//  Created by Evelina on 26.06.2025.
//

import SwiftUI

struct DeviceShakeViewModifier: ViewModifier {
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

