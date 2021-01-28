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
        default:
            return ukrainian
        }
    }
    var images = [String]()
    var isFavorite = false
    var id: String?
    var dict: [String:Any] {
        return ["id": id ?? "",
                "isFavorite": isFavorite,
                "images": images,
                "uk": ukrainian?.dict ?? [:]
        ]
    }
    
    private var ukrainian: LocalizeRoadSign?
    private var english: LocalizeRoadSign?

    //MARK: - Initalizer
    
    init(from dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        handleImagesDecoding(from: dictionary)
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
    
    private func handleImagesDecoding(from dict: NSDictionary) {
        if let images = dict["images"] as? [String] {
            self.images = images
        }else {
            decodeImageArray(from: dict["images"] as? NSDictionary ?? [:])
        }
    }
}

