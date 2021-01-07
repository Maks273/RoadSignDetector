//
//  History.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 05.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import Foundation

enum HistoryType {
    case all
    case favorite
}

class History {
    
    var all = [RoadSign]()
    var favorite = [RoadSign]()
    
//    var toDictionary: NSDictionary{
//        return ["":""]
//    }
    
    init() {
    }
    
    init(from dictionary: NSDictionary) {
        all = FirebaseService.shared.decodeDataToRoadSignArray(from: dictionary)
    }

}

