//
//  Enviroment.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 05.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class Environment {
    
    private init() {}
    
    static let shared = Environment()
    
    var currentUser: User?
}
