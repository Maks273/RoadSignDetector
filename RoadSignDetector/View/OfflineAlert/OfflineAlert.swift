//
//  OfflineAlert.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 10.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class OfflineAlert: UIView {
    
    //MARK: - Variables
    
    var timer: Timer?
    var shapeLayer: CAShapeLayer?
    
    //MARK: - Initalizer/Deinitalizer
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        invalidateTimer()
    }
    
    //MARK: - Override methods
    
    override func draw(_ rect: CGRect) {
        configureBackgroundStyle()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(drawWifi), userInfo: nil, repeats: true)
        drawWifi()
    }
    
    //MARK: - Private methods
    
    private func configureBackgroundStyle() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 15
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
    }
    
    private func invalidateTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    
    //MARK: - Drawing
    
    @objc private func drawWifi() {
        clearShapeLayer()
        
        let logo = drawWifiLogo(in: bounds)
        configureShapeLayer(with: logo.cgPath)
        setShapeLayerAnimation()
    }
    
    private func drawWifiLogo(in rect: CGRect) -> UIBezierPath {
        let logo = UIBezierPath()
        //circle
        logo.addArc(withCenter: CGPoint(x: rect.midX, y: 120), radius: CGFloat(4), startAngle: CGFloat(0), endAngle: CGFloat(360), clockwise: true)
        // bottom line
        logo.move(to: CGPoint(x: 60, y: 100))
        logo.addQuadCurve(to: CGPoint(x: 100, y: 100), controlPoint: CGPoint(x: rect.midX, y: 85))
        // mid line
        logo.move(to: CGPoint(x: 40, y: 80))
        logo.addQuadCurve(to: CGPoint(x: 120, y: 80), controlPoint: CGPoint(x: rect.midX, y: 50))
        // top line
        logo.move(to: CGPoint(x: 20, y: 60))
        logo.addQuadCurve(to: CGPoint(x: 140, y: 60), controlPoint: CGPoint(x: rect.midX, y: 15))
        logo.move(to: CGPoint(x: rect.midX, y: 120))
        return logo
    }
    
    private func configureShapeLayer(with path: CGPath) {
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer?.strokeColor = UIColor.black.cgColor
        self.shapeLayer?.fillColor = UIColor.white.cgColor
        self.shapeLayer?.lineWidth = 8
        self.shapeLayer?.path = path
        self.shapeLayer?.strokeEnd = 0
        self.layer.addSublayer(self.shapeLayer ?? CAShapeLayer())
    }
    
    private func clearShapeLayer() {
        if self.shapeLayer != nil {
            self.shapeLayer?.removeFromSuperlayer()
        }
    }
    
    private func setShapeLayerAnimation() {
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = 1
        startAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        startAnimation.toValue = 0
        startAnimation.duration = 10
        self.shapeLayer?.strokeEnd = 5
        self.shapeLayer?.add(startAnimation, forKey: "MyAnimation")
    }
    
}
