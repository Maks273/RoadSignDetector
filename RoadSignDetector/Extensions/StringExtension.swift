//
//  StringExtension.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 02.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
