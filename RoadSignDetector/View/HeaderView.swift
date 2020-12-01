//
//  HeaderView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyle()
    }
    
    func configureStyle(){
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.purple.cgColor
        
        setupShadow()
    }
    
    private func setupShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.55
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
    
}
