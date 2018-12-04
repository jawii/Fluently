//
//  CounterView.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 04/12/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit

class CounterView: UIView {
    
    private let answeredFillColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
    private let initialFillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    private let strokeColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    private let currentCountColor = GlobalConstants.Color.coral
    
    var totalCount: Int = 10 {
        didSet {
            drawCountCircles()
        }
    }
    var current: Int = 0
    
    private var countLayers = [CAShapeLayer]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func drawCountCircles() {
        print("Drawing countcirclers")
        let spaceCoeff:CGFloat = 1.0
        let width = self.frame.width / ( CGFloat(totalCount) + spaceCoeff * (CGFloat(totalCount) - CGFloat(1)))
        
        for i in 1 ... totalCount {
            let shapeLayer = CAShapeLayer()
            
            let count = CGFloat(i)
            let centerPoint = CGPoint(x: count * width - width / 2.0 + (count - 1) * spaceCoeff * width, y: self.frame.height / 2.0)
            
            let circlePath = UIBezierPath(arcCenter: centerPoint, radius: width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            
            shapeLayer.path = circlePath.cgPath
            
            shapeLayer.fillColor = initialFillColor.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = 0

            self.layer.addSublayer(shapeLayer)
            
            countLayers.append(shapeLayer)
        }
    }
    
    func addCount() {
        guard current <= totalCount - 1 else {
            print("Out of bounds")
            let shapeLayer = countLayers.last!
            animateLayerBackgroundColorTo(layer: shapeLayer, color: answeredFillColor.cgColor)
            shapeLayer.lineWidth = 1
            return
        }
        // Animate previous
        if current > 0 {
            let shapeLayer = countLayers[current - 1]
            animateLayerBackgroundColorTo(layer: shapeLayer, color: answeredFillColor.cgColor)
            shapeLayer.lineWidth = 1
        }
        
        let shapeLayer = countLayers[current]
        animateLayerBackgroundColorTo(layer: shapeLayer, color: currentCountColor.cgColor)
        
        current += 1
    }
    
    func decreaseCount() {
        guard current > 1 else {
            print("Out of bounds")
            return
        }
        
        // If finished, turn last one to orange
        //        if current == totalCount {
        //            let layer = countLayers.last!
        //            animateLayerBackgroundColorTo(layer: layer, color: currentCountColor.cgColor)
        //            current -= 1
        //            return
        //        }
        
        // animate current to gray
        let currentLayer = countLayers[current - 1]
        animateLayerBackgroundColorTo(layer: currentLayer, color: initialFillColor.cgColor)
        
        // animate previous to orange
        if current > 0 {
            animateLayerBackgroundColorTo(layer: countLayers[current - 2], color: currentCountColor.cgColor)
        }
        
        current -= 1
    }
    
    private func animateLayerBackgroundColorTo(layer: CAShapeLayer, color: CGColor) {
        let anim = CABasicAnimation(keyPath: "fillColor")
        //        anim.fromValue = layer.fillColor
        anim.toValue = color
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.isRemovedOnCompletion = false
        anim.fillMode = .forwards
        
        
        layer.add(anim, forKey: "fillColor")
    }
}
