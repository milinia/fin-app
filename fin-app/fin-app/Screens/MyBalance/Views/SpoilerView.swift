//
//  SpoilerView.swift
//  fin-app
//
//  Created by Evelina on 27.06.2025.
//

import SwiftUI

struct SpoilerView: UIViewRepresentable {
    
    var isSpoilerVisible: Bool

    func makeUIView(context: Context) -> SpoilerEmitterView {
        let view = SpoilerEmitterView()
        
        let image = UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal).cgImage
        
        let cell = CAEmitterCell()
        cell.contents = image
        cell.contentsScale = 1.8
        cell.emissionRange = .pi * 2
        cell.lifetime = 1
        cell.scale = 0.05
        cell.velocityRange = 20
        cell.alphaRange = 1
        cell.birthRate = 1500
        
        view.layer.emitterCells = [cell]
        view.layer.emitterShape = .rectangle
        
        return view
    }
    
    func updateUIView(_ uiView: SpoilerEmitterView, context: Context) {
        if isSpoilerVisible {
            uiView.layer.beginTime = CACurrentMediaTime()
        }
        
        uiView.layer.birthRate = isSpoilerVisible ? 1 : 0
    }
}

#Preview {
    SpoilerView(isSpoilerVisible: true)
}
