//
//  Enviroment.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 05.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Reachability

class Environment {
  
    //MARK: - Variables
    
    static let shared = Environment()
    
    var currentUser: User?
    var currentLocalizationInfo: LocalizationInfo = .ukrainian
    var selectedTabIndex: Int = 1
    var currentConnectionStatus: Reachability.Connection! {
        didSet {
            postCurrentConnectionStatusObserver()
        }
    }
    var currentVoice: VoiceType = .man

    private let voiceKey = "Voice"
    
    
    //MARK: - Initalizer
    
    private init() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currentConnectionStatusWasChanged, object: nil)
    }
    
    //MARK: - Helper
    
    func saveCurrentVoice(_ voiceValue: String) {
        UserDefaults.standard.setValue(voiceValue, forKey: voiceKey)
    }
    
    func loadCurrentVoice() -> String {
        return UserDefaults.standard.string(forKey: voiceKey) ?? ""
    }
    
    func changeCurrentVoiceType() {
        let voice = loadCurrentVoice()
        currentVoice = voice == VoiceType.man.rawValue ? .man : .woman
    }
    
    //MARK: - Private methods
    
    private func postCurrentConnectionStatusObserver() {
        NotificationCenter.default.post(name: .currentConnectionStatusWasChanged, object: nil)
    }
}
