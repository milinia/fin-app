//
//  SpoilerEmitterView.swift
//  fin-app
//
//  Created by Evelina on 27.06.2025.
//

import Foundation
import UIKit

final class SpoilerEmitterView: UIView {
    override class var layerClass: AnyClass {
        CAEmitterLayer.self
    }
     
    override var layer: CAEmitterLayer {
        super.layer as! CAEmitterLayer
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.emitterPosition = .init(x: bounds.midX, y: bounds.midY)
        layer.emitterSize = bounds.size
    }
}
