//
//  LocalizeRoadSign.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 21.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class LocalizeRoadSign {
    
    //MARK: - Variables
    
    var description: String?
    var sound: Voice?
    var title: String?
    var dict: [String:Any] {
        return ["description": description ?? "",
                "title": title ?? "",
                "sound": sound?.dict ?? [:]
        ]
    }
    
    //MARK: - Initalizer
    
    init(from dictionary: NSDictionary) {
        description = String(dictionary["description"] as? String ?? "")
        if let soundDict = dictionary["sound"] as? NSDictionary {
            sound = Voice(from: soundDict)
        }
        title = dictionary["title"] as? String
    }
}
