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
        images = dictionary["images"] as? [String] ?? []
        ukrainian = LocalizeRoadSign(from: dictionary["uk"] as? NSDictionary ?? [:])
        isFavorite = dictionary["isFavorite"] as? Bool ?? false
    }
}

class LocalizeRoadSign: Codable {
    
    //MARK: - Variables
    
    var description: String?
    var soundStringURL: String?
    var title: String?
    
    //MARK: - Initalizer
    
    init(from dictionary: NSDictionary) {
        description = String(dictionary["description"] as? String ?? "")
        soundStringURL = dictionary["sound"] as? String
        title = dictionary["title"] as? String
    }
}

