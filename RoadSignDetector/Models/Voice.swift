//
//  Sound.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 19.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

enum VoiceType: String {
    case man = "Man"
    case woman = "Woman"
}

class Voice {
    
    //MARK: - Variables
    
    private var man: String?
    private var woman: String?
    var dict: [String:Any] {
        return ["man": man ?? "",
                "woman": woman ?? ""
        ]
    }
    
    //MARK: - Initalizer
    
    init(from dict: NSDictionary) {
        man = dict["man"] as? String
        woman = dict["woman"] as? String
    }
    
    //MARK: - Helper
    
    func name() -> String? {
        return Environment.shared.currentVoice == .man ? man : woman
    }

}
