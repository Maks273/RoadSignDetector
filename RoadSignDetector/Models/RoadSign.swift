//
//  RoadSign.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import Foundation


class RoadSign {
    
    var ukrainian: LocalizeRoadSign?
    var images = [String]()
    var isFavorite = false
    var id: String?

    init(from dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        images = dictionary["images"] as? [String] ?? []
        ukrainian = LocalizeRoadSign(from: dictionary["uk"] as? NSDictionary ?? [:])
        isFavorite = dictionary["isFavorite"] as? Bool ?? false
    }
}

class LocalizeRoadSign: Codable {
    
    var description: String?
    var soundStringURL: String?
    var title: String?
    
    init(from dictionary: NSDictionary) {
        description = String(dictionary["description"] as? String ?? "")
        soundStringURL = dictionary["sound"] as? String
        title = dictionary["title"] as? String
    }
}

