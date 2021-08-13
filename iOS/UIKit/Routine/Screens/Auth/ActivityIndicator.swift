//
//  SpinningIndicator.swift
//  Teams
//
//  Created by Vadzim Karonchyk on 06/17/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

final class ActivityIndicatorView: UIView {

    private let circleLayer = CAShapeLayer()
    private let backgroundCircleLayer = CAShapeLayer()
    
    var lineWidth: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var primaryColor = UIColor.gray {
        didSet {
            circleLayer.strokeColor = primaryColor.cgColor
        }
    }
    var secondaryColor = UIColor.lightGray {
        didSet {
            backgroundCircleLayer.strokeColor = secondaryColor.cgColor
        }
    }
    
    private(set) var isAnimating = false
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        
        backgroundCircleLayer.lineWidth = lineWidth
        backgroundCircleLayer.fillColor = nil
        layer.addSublayer(backgroundCircleLayer)
        
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = nil
        circleLayer.lineCap = .round
        layer.addSublayer(circleLayer)
    }
    
    override func draw(_ rect: CGRect) {
        let size = min(bounds.width, bounds.height)
        let rect = CGRect(x: lineWidth/2,
                          y: lineWidth/2,
                          width: size - lineWidth,
                          height: size - lineWidth)
        
        let path = UIBezierPath(ovalIn: rect)
        backgroundCircleLayer.path = path.cgPath
        
        let startAngle = -CGFloat(Double.pi/2)
        let endAngle = startAngle + CGFloat(Double.pi*2)
        let radius = size/2 - lineWidth/2
        let circlePath = UIBezierPath(
            arcCenter: .zero,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        circleLayer.path = circlePath.cgPath
        circleLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func setupAnimations() {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 2
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let strokeEndAnimationGroup = CAAnimationGroup()
        strokeEndAnimationGroup.duration = 2.5
        strokeEndAnimationGroup.repeatCount = Float.infinity
        strokeEndAnimationGroup.animations = [strokeEndAnimation]
        circleLayer.add(strokeEndAnimationGroup, forKey: "strokeEnd")
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.beginTime = 0.5
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1.0
        strokeStartAnimation.duration = 2
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let strokeStartAnimationGroup = CAAnimationGroup()
        strokeStartAnimationGroup.duration = 2.5
        strokeStartAnimationGroup.repeatCount = Float.infinity
        strokeStartAnimationGroup.animations = [strokeStartAnimation]
        circleLayer.add(strokeStartAnimationGroup, forKey: "strokeStart")

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 4
        rotationAnimation.repeatCount = .infinity
        circleLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    private func removeAnimations() {
        circleLayer.removeAllAnimations()
    }
    
    func startAnimating() {
        setupAnimations()
        isAnimating = true
    }
    
    func stopAnimating() {
        removeAnimations()
        isAnimating = false
    }
}

extension Reactive where Base: ActivityIndicator {

    /// Bindable sink for `show()`, `hide()` methods.
    public static var isAnimating: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { progressHUD, isVisible in
            if isVisible {
                progressHUD.show() // or other show methods
            } else {
                progressHUD.dismiss() // or other hide methods
            }
        }
    }

}
