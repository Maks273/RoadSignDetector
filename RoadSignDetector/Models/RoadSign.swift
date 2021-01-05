//
//  RoadSign.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import Foundation


struct RoadSign {
    var title: String
    var desription: String
    var imageStringURL: String
    
    var imageURL: URL? {
        return URL(string: self.imageStringURL)
    }
}
