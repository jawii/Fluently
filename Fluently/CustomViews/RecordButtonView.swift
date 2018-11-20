//
//  RecordButtonView.swift
//  Fluently
//
//  Created by Jaakko Kenttä on 17/11/2018.
//  Copyright © 2018 Jaakko Kenttä. All rights reserved.
//

import UIKit


class RecordButtonView: UIView {
    
    private let recordRed = GlobalConstants.Color.coral
    private let recordRed2 = #colorLiteral(red: 1, green: 0.3607843137, blue: 0.007843137255, alpha: 0.9)
    private let playBlue = UIColor(red: 0.102, green: 0.427, blue: 0.816, alpha: 1.000)
    var outlineLayer =  CAShapeLayer()
    var centerLayer = CAShapeLayer()
    private var recordRectLayer1 = CAShapeLayer()
    private var recordRectLayer2 = CAShapeLayer()
    
    var stopRects = CAShapeLayer()
    private var shootRight: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outlineLayer.path = self.drawOutline().cgPath
        outlineLayer.fillColor = nil
        outlineLayer.strokeColor = UIColor.black.cgColor
        outlineLayer.lineWidth = 3
        
        drawPlayButtonTriangle()
        self.layer.addSublayer(outlineLayer)
        self.layer.addSublayer(centerLayer)
        self.centerLayer.addSublayer(recordRectLayer1)
        self.centerLayer.addSublayer(recordRectLayer2)
    }
    
    // This non-generic function dramatically improves compilation times of complex expressions.
    private func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
    
    private func drawOutline() -> UIBezierPath {
        let circle = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 4, dy: 4))
        return circle
    }
    
    func resetLayers() {
        centerLayer.removeAllAnimations()
        centerLayer.path = nil
        centerLayer.fillColor = nil
        centerLayer.strokeColor = nil
        stopRects.path = nil
        recordRectLayer1.path = nil
        recordRectLayer2.path = nil
    }
    
    func recordingStarted() {
        resetLayers()
        drawRecordButton()
    }
    func recordingStopped() {
        resetLayers()
        drawPlayButtonTriangle()
    }

    private func drawPlayButtonTriangle(){
        let polygonPath = recordTrianglePath()
        
        centerLayer.path = polygonPath.cgPath
        centerLayer.fillColor = nil
        centerLayer.strokeColor = playBlue.cgColor
        centerLayer.lineCap = .round
        centerLayer.lineJoin = .round
        centerLayer.lineWidth = 3
    }
    private func drawRecordButton() {
        let bg = self.recordingBackgroundPath()
        centerLayer.path = bg.cgPath
        centerLayer.fillColor = recordRed.cgColor
        centerLayer.strokeColor = nil
        
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.fromValue = recordRed.cgColor
        animation.toValue = recordRed2.cgColor
        animation.duration = 0.5
        animation.repeatCount = Float.infinity
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = true
        centerLayer.add(animation, forKey: "fillColor")
        
        let stopRecordRectangles = stopRecordRectPaths()
        
        recordRectLayer1.path = stopRecordRectangles[0].cgPath
        recordRectLayer1.fillColor = UIColor.white.cgColor
        recordRectLayer1.lineCap = .round
        
        recordRectLayer2.path = stopRecordRectangles[1].cgPath
        recordRectLayer2.fillColor = UIColor.white.cgColor
        recordRectLayer2.lineCap = .round
    }
    
    private func recordTrianglePath() -> UIBezierPath {
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: bounds.minX + 0.72667 * bounds.width, y: bounds.minY + 0.50000 * bounds.height))
        polygonPath.addLine(to: CGPoint(x: bounds.minX + 0.38667 * bounds.width, y: bounds.minY + 0.68475 * bounds.height))
        polygonPath.addLine(to: CGPoint(x: bounds.minX + 0.38667 * bounds.width, y: bounds.minY + 0.31525 * bounds.height))
        polygonPath.addLine(to: CGPoint(x: bounds.minX + 0.72667 * bounds.width, y: bounds.minY + 0.50000 * bounds.height))
        polygonPath.close()
        return polygonPath
    }
    /// Draws the outline for recording
    private func recordingBackgroundPath() -> UIBezierPath {
        let oval = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 12, dy: 12))
        return oval
    }
    /// Draws the rectangles
    private func stopRecordRectPaths() -> [UIBezierPath] {
        let rectanglePath = UIBezierPath(rect: CGRect(x: bounds.minX + fastFloor(bounds.width * 0.40000 + 0.5), y: bounds.minY + fastFloor(bounds.height * 0.35 + 0.5), width: fastFloor(bounds.width * 0.46667 + 0.5) - fastFloor(bounds.width * 0.40000 + 0.5), height: fastFloor(bounds.height * 0.64000 + 0.5) - fastFloor(bounds.height * 0.35 + 0.5)))
        
        let rectangle2Path = UIBezierPath(rect: CGRect(x: bounds.minX + fastFloor(bounds.width * 0.54667 + 0.5), y: bounds.minY + fastFloor(bounds.height * 0.35 + 0.5), width: fastFloor(bounds.width * 0.61333 + 0.5) - fastFloor(bounds.width * 0.54667 + 0.5), height: fastFloor(bounds.height * 0.64000 + 0.5) - fastFloor(bounds.height * 0.35 + 0.5)))
        
        return [rectanglePath, rectangle2Path]
    }
    
    //---------------
    // WORD SHOOTING
    // --------------
    private func createCurveForWordShooting(fromPoint startPoint: CGPoint) -> UIBezierPath {
        // Create curve
        let curve = UIBezierPath()
        let centerX = self.bounds.minX + self.bounds.width / 2.0
        curve.move(to: startPoint)
        
        var xDirection: CGFloat
        if self.shootRight {
            xDirection = CGFloat.random(in: 20...150)
        } else {
            xDirection = CGFloat.random(in: -150 ... -20)
        }
        shootRight = !shootRight
        
        let firstControlPoint = CGPoint(x: centerX, y: self.bounds.minY - 100)
        let secondControlPoint = CGPoint(x: centerX + xDirection, y: startPoint.y - CGFloat.random(in: 25...75))
        curve.addCurve(to: secondControlPoint, controlPoint1: firstControlPoint, controlPoint2: secondControlPoint)
        
        return curve
    }
    private func createTextLayer(at position: CGPoint, withString word: String) -> CATextLayer {
        let textLayer = CATextLayer()
       
        textLayer.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.position = position
        textLayer.string = word
        textLayer.font = FONTAvenirNextFamily.Regular.CTFont(size: 8)
        textLayer.fontSize = 14
        
        textLayer.isWrapped = true
        textLayer.truncationMode = .none
        
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = UIColor.black.cgColor
        self.layer.addSublayer(textLayer)
        
        return textLayer
    }
    
    func shootWord(word: String) {
        
        let centerX = self.bounds.minX + self.bounds.width / 2.0
        let startPoint = CGPoint(x: centerX, y: self.bounds.minY)
        let curve = createCurveForWordShooting(fromPoint: startPoint)
        
        //  Create line for the shooted word
        let bezierLayer = CAShapeLayer()
        bezierLayer.path = curve.cgPath
        bezierLayer.strokeColor = UIColor.lightGray.cgColor
        bezierLayer.fillColor = nil
        self.layer.addSublayer(bezierLayer)
        
        let textLayer = createTextLayer(at: startPoint, withString: word)
        
        // Add animation to Bezier curve
        let curveAnim = CABasicAnimation(keyPath: "strokeEnd")
        curveAnim.duration = 2.5
        curveAnim.fromValue = 0
        curveAnim.toValue = 1.0
        bezierLayer.add(curveAnim, forKey: "strokeAnimation")
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.duration = 1.75
        alphaAnim.fromValue = 1.0
        alphaAnim.toValue = 0.0
        alphaAnim.isRemovedOnCompletion = false
        alphaAnim.fillMode = CAMediaTimingFillMode.forwards
        bezierLayer.add(alphaAnim, forKey: "alphaAnimation")
        
        // Add animation to TextLayer
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = curve.cgPath
        animation.repeatCount = 1
        animation.duration = 1.75
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = CGFloat.random(in: -3.141...3.141)
        rotateAnimation.duration = 2.0
        
        let group = CAAnimationGroup()
        group.fillMode = CAMediaTimingFillMode.forwards
        group.isRemovedOnCompletion = false
        group.duration = 4
        group.animations = [animation, rotateAnimation]
        textLayer.add(group, forKey: "animation")
        
        // Remove Text Layer
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            textLayer.removeFromSuperlayer()
        }
    }
}


/*
 private func animatePathChange(for layer: CAShapeLayer, toPath: CGPath) {*
 let animation = CABasicAnimation(keyPath: "path")
 animation.duration = 0.5
 animation.fromValue = layer.path
 animation.toValue = toPath
 animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
 //CAMediaTimingFunctionName(rawValue: "easeInEaseOut")
 animation.isRemovedOnCompletion = false
 animation.fillMode = CAMediaTimingFillMode.forwards
 layer.add(animation, forKey: "path")
 }
 */
