//
//  UIWindow+MotionEnded.swift
//  fin-app
//
//  Created by Evelina on 26.06.2025.
//

import Foundation
import UIKit

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}
