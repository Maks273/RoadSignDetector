//
//  UIButtonExtenstion.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 26.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

extension UIButton {
    func localizedTitle() {
        self.setTitle(self.titleLabel?.text?.localized(), for: .normal)
    }
}
