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
        let currentLanguage = UserDefaults.standard.string(forKey: Environment.shared.appLanguageKey) ?? Environment.shared.ukLanguageKey
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else {
            return ""
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: self)
    }
}
