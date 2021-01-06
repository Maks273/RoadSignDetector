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
    
    var toDictionary: NSDictionary{
        return ["all": "",
                "favorite": ""]
    }
    
    init() {
    }
    
    init(from dictionary: NSDictionary) {
        all = FirebaseService.shared.decodeDataToRoadSignArray(from: dictionary["all"] as? NSDictionary ?? [:])
        favorite = FirebaseService.shared.decodeDataToRoadSignArray(from: dictionary["favorite"] as? NSDictionary ?? [:])
    }
    
//    private func decodeDataToRoadSignArray(from dicts: NSDictionary) -> [RoadSign] {
//        var decodedArray = [RoadSign]()
//
//        for item in dicts {
//            if let itemValueDict = item.value as? NSDictionary {
//                let decodedItem = RoadSign(from: itemValueDict)
//                decodedArray.append(decodedItem)
//            }
//        }
//        return decodedArray
//    }
}

