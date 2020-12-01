//
//  LanguageView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 29.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class AudioView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupBottomContainerStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupBottomContainerStyle()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("AudioView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    private func setupBottomContainerStyle(){
        containerView.layer.cornerRadius = 7
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
    @IBAction func soundSwitcherWasToggled(_ sender: Any) {
        print("))))))))))))))")
    }
}
