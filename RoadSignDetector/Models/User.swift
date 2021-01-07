//
//  User.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 05.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class User {
    
    var phoneName: String?
    var phoneUID: String?
    var history: History?
    
    var userDictionary: NSDictionary{
        return [ "phoneName": phoneName ?? "",
                 "phoneUID": phoneUID ?? "",
                 "history": ""
        ]
    }
    
    init(phoneName: String, phoneUID: String, history: History) {
        self.phoneName = phoneName
        self.phoneUID = phoneUID
        self.history = history
    }
    
    init(from dictionary: NSDictionary) {
        phoneName = dictionary["phoneName"] as? String ?? ""
        phoneUID = dictionary["phoneUID"] as? String ?? ""
        if let historyDict = dictionary["history"] as? NSDictionary {
            history = History(from: historyDict)
        }
    }
    
}
