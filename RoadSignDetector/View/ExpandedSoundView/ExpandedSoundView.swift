//
//  ExpandedSoundView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 15.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class ExpandedSoundView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!

    //MARK: - Initalizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ExpandedSoundView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setupContainerStyle()
    }
    
    private func setupContainerStyle() {
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.55
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
    }
    
    //MARK: - IBActions
    
    @IBAction func collapsedBtnWasPressed(_ sender: Any) {
        
    }
    

}
