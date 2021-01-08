//
//  Enviroment.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 05.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class Environment {
  
    //MARK: - Variables
    
    static let shared = Environment()
    
    var currentUser: User?
    var currentLocalizationInfo: LocalizationInfo = .ukrainian
    
    //MARK: - Initalizer
    
    private init() {}
    
    //MARK: - Helper
    
}
