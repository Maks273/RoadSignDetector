//
//  UILabelExtension.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 16.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

extension UILabel {
    func configureNoDataLabel(for view: UIView) {
        self.frame =  CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.translatesAutoresizingMaskIntoConstraints = true
        self.numberOfLines = 2
        self.textAlignment = .center
        self.text = "There are no data at the moment.".localized()
        self.font = UIFont(name: "AvenirNext-Regular", size: 17)
    }
    
    func localizedText() {
        text = text?.localized()
    }
}
