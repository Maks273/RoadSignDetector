//
//  RoadSign.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import Foundation

enum LocalizationInfo {
    case ukrainian
    case english
}

class RoadSign {
    
    //MARK: - Variables
    
    var localizationInfo: LocalizeRoadSign? {
        switch Environment.shared.currentLocalizationInfo {
        case .ukrainian:
            return ukrainian
        case .english:
            return english
        }
    }
    var images = [String]()
    var isFavorite = false
    var id: String?
    
    private var ukrainian: LocalizeRoadSign?
    private var english: LocalizeRoadSign?

    //MARK: - Initalizer
    
    init(from dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        decodeImageArray(from: dictionary["images"] as? NSDictionary ?? [:])
        ukrainian = LocalizeRoadSign(from: dictionary["uk"] as? NSDictionary ?? [:])
        isFavorite = dictionary["isFavorite"] as? Bool ?? false
    }
    
    //MARK: - Private methods
    
    private func decodeImageArray(from dict: NSDictionary) {
        for item in dict {
            if let itemValue = item.value as? String {
                images.append(itemValue)
            }
        }
    }
}

class LocalizeRoadSign {
    
    //MARK: - Variables
    
    var description: String?
    var sound: Voice?
    var title: String?
    
    //MARK: - Initalizer
    
    init(from dictionary: NSDictionary) {
        description = String(dictionary["description"] as? String ?? "")
        if let soundDict = dictionary["sound"] as? NSDictionary {
            sound = Voice(from: soundDict)
        }
        title = dictionary["title"] as? String
    }
}

