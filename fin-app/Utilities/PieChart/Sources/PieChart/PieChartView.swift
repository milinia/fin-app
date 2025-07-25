//
//  PieChartView.swift
//  PieChart
//
//  Created by Evelina on 22.07.2025.
//

import Foundation
import UIKit

public class PieChartView: UIView {
    
    private var entities: [Entity] = []
    
    private let colors: [UIColor] = [.yellow, .green, .red, .blue, .purple, .brown]
    
    private var pieChartCenter: CGPoint {
        CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var radius: CGFloat {
        min(bounds.width, bounds.height) / 2.5
    }
    
    private var lineWidth: CGFloat {
        10
    }
    
    private var circleSize: CGSize {
        return CGSize(width: 5.65, height: 5.65)
    }
    
    private var legendFontSize: CGFloat {
        7
    }

    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !entities.isEmpty else { return }
        
        drawPieChart()
    }
    
    public func reloadData(with entities: [Entity]) {
        self.entities = entities
        
        subviews.forEach { $0.removeFromSuperview() }
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        setNeedsDisplay()
    }
    
    private func drawPieChart() {
        var startAngle: CGFloat = -.pi / 2
        var othersCategoryValue: Double = 0
        
        for i in 0...min(entities.count - 1, 4) {
            let doubleValue: Double = (entities[i].value as NSDecimalNumber).doubleValue
            let endAngle: CGFloat = startAngle + (2 * .pi) * (doubleValue / 100)
            othersCategoryValue += doubleValue
            
            let shapeLayer = makeShapeLayer(
                startAngle: startAngle,
                endAngle: endAngle,
                color: colors[i % colors.count]
            )
            
            layer.addSublayer(shapeLayer)
            
            startAngle = endAngle
        }
        
        if entities.count > 5, let color = colors.last {
            othersCategoryValue = 100 - othersCategoryValue
            
            let endAngle: CGFloat = startAngle + (2 * .pi) * (othersCategoryValue / 100)
            
            let shapeLayer = makeShapeLayer(
                startAngle: startAngle,
                endAngle: endAngle,
                color: color
            )
            
            layer.addSublayer(shapeLayer)
        }
        
        drawPieChartLegend(othersCategoryValue: othersCategoryValue)
    }
    
    private func makeShapeLayer(
        startAngle: CGFloat,
        endAngle: CGFloat,
        color: UIColor
    ) -> CAShapeLayer {
        let path = UIBezierPath(
            arcCenter: pieChartCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .butt
        
        return shapeLayer
    }
    
    private func drawPieChartLegend(othersCategoryValue: Double) {
        let legendView = UIStackView()
        legendView.axis = .vertical
        legendView.alignment = .leading
        legendView.distribution = .fillEqually
        legendView.spacing = 5
        legendView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0...min(entities.count - 1, 4) {
            let stackView = makeHorizontalStackView(entity: entities[i], color: colors[i])
            legendView.addArrangedSubview(stackView)
        }
        
        if entities.count > 5, let color = colors.last {
            let stackView = makeHorizontalStackView(
                entity: Entity(
                    value: Decimal(othersCategoryValue),
                    label: "Остальные"
                ),
                color: color
            )
            legendView.addArrangedSubview(stackView)
        }
        
        addSubview(legendView)
        NSLayoutConstraint.activate([
            legendView.centerXAnchor.constraint(equalTo: centerXAnchor),
            legendView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func makeHorizontalStackView(entity: Entity, color: UIColor) -> UIStackView {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: legendFontSize, weight: .regular)
        label.text = "\(entity.value)% \(entity.label)"
        
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.layer.cornerRadius =  circleSize.width / 2
        circleView.backgroundColor = color
        
        let hStackView = UIStackView(arrangedSubviews: [circleView, label])
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal
        hStackView.spacing = 3
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: circleSize.width),
            circleView.heightAnchor.constraint(equalToConstant: circleSize.height)
        ])
        
        return hStackView
    }
}
