//
//  UIViewExtension.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

extension UIView {
    func setShadow(with yCoef: CGFloat) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowPath = UIBezierPath(rect: CGRect( x: 10,
                                                        y: self.bounds.maxY + yCoef ,
                                                        width: self.bounds.width - 40,
                                                        height: 3)).cgPath
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 4.0
        self.layer.cornerRadius = 7
        
    }
    
    func defalutVerticalLine(with maskedCorners:  CACornerMask, cornerRadius: CGFloat) {
        self.backgroundColor = .purple
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = maskedCorners
    }
}
