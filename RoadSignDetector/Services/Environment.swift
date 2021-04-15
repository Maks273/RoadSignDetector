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
    var currentLocalizationInfo: LocalizationInfo!
    var selectedTabIndex: Int = 1
    var currentConnectionStatus: Reachability.Connection! {
        didSet {
            postCurrentConnectionStatusObserver()
        }
    }
    var currentVoice: VoiceType = .man
    var playSoundStatus: Bool = false
    let appLanguageKey = "AppleLanguage"
    let ukLanguageKey = "uk"

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
        return UserDefaults.standard.string(forKey: voiceKey) ?? "man"
    }
    
    func changeCurrentVoiceType() {
        let voice = loadCurrentVoice()
        currentVoice = voice == "" ? .man : VoiceType.man.rawValue == voice ? .man : .woman
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
    
    func changeCurrentLocalizeIntoLanguage() {
        let currentLanguage = UserDefaults.standard.string(forKey: Environment.shared.appLanguageKey) ?? Environment.shared.ukLanguageKey
        switch currentLanguage {
        case ukLanguageKey:
            currentLocalizationInfo = .ukrainian
        case "en":
            currentLocalizationInfo = .ukrainian
        case "ru":
            currentLocalizationInfo = .ukrainian
        default:
            currentLocalizationInfo = .ukrainian
        }
    }
    
    //MARK: - Private methods
    
    private func postCurrentConnectionStatusObserver() {
        NotificationCenter.default.post(name: .currentConnectionStatusWasChanged, object: nil)
    }
}
