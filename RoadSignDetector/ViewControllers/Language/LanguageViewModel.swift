//
//  LanguageViewModel.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 01.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class LanguageViewModel {
    private let languages = ["English 🇺🇸".localized(),"Ukrainian 🇺🇦".localized(),"Russian 🇷🇺".localized()]
    private let languageCode = ["en","uk","ru"]
    
    func getCellNumber() -> Int {
        return languages.count
    }
    
    func isLastCell(at indexPath: IndexPath) -> Bool {
        return indexPath.row == languages.count-1
    }
    
    func getTitle(at indexPath: IndexPath) -> String {
        return indexPath.row > languages.count-1 ? "" : languages[indexPath.row]
    }
    
    func getLanguageCode(for indexPath: IndexPath) -> String {
        return indexPath.row > languageCode.count-1 ? "" : languageCode[indexPath.row]
    }
}
