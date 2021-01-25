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
    var playSoundStatus: Bool = false

    private let voiceKey = "Voice"
    private let playSoundKey = "PlaySound"
    
    
    //MARK: - Initalizer
    
    private init() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currentConnectionStatusWasChanged, object: nil)
    }
    
    //MARK: - Helper
    
        //MARK:  Current voice settings item
    
    func saveCurrentVoice(_ voiceValue: String) {
        UserDefaults.standard.setValue(voiceValue, forKey: voiceKey)
    }
    
    func loadCurrentVoice() -> String {
        return UserDefaults.standard.string(forKey: voiceKey) ?? ""
    }
    
    func changeCurrentVoiceType() {
        let voice = loadCurrentVoice()
        print("LOADED = \(voice)")
        currentVoice = voice == VoiceType.man.rawValue ? .man : .woman
        print("Current = \(currentVoice)")
    }
    
        //MARK:  Play sound settings item
    
    func savePlaySoundStatus(_ status: Bool) {
        UserDefaults.standard.setValue(status, forKey: playSoundKey)
    }
    
    func loadPlaySoundStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: playSoundKey)
    }
    
    func changePlaySoundStatus() {
        let status = loadPlaySoundStatus()
        playSoundStatus = status
    }
    
    //MARK: - Private methods
    
    private func postCurrentConnectionStatusObserver() {
        NotificationCenter.default.post(name: .currentConnectionStatusWasChanged, object: nil)
    }
}
