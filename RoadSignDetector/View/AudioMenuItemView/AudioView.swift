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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("AudioView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.tag = 8
    }

    @IBAction func soundSwitcherWasToggled(_ sender: Any) {
        print("))))))))))))))")
    }
}
