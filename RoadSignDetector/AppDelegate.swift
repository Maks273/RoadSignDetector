//
//  AppDelegate.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDefauldLanguageIfNeeded()
        Environment.shared.changeCurrentLocalizeIntoLanguage()
        NetworkService.shared.startObserving()
        FirebaseApp.configure()
        handleUserAuthorization()
        changeCurrentVoice()
        changePlaySoundStatus()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - Private methods
    
    private func handleUserAuthorization() {
        FirebaseService.shared.handleAuthorization { (user) in
            Environment.shared.currentUser = user
            NotificationCenter.default.post(name: Notification.Name.currentUserWasIdenfied, object: nil)
        }
    }
    
    private func changeCurrentVoice() {
        Environment.shared.changeCurrentVoiceType()
    }
    
    private func changePlaySoundStatus() {
        Environment.shared.changePlaySoundStatus()
    }
    
    private func setupDefauldLanguageIfNeeded() {
        if UserDefaults.standard.string(forKey: Environment.shared.appLanguageKey) == nil {
            UserDefaults.standard.setValue("en", forKey: Environment.shared.appLanguageKey)
        }
    }

}
