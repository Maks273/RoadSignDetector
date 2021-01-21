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

    let currentLanguage = UserDefaults.standard.string(forKey: "AppleLanguage")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //UserDefaults.standard.set(currentLanguage, forKey: "AppleLanguage"
        Bundle.swizzleLocalization()
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

}

extension Bundle {


    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }

    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let bundlePath = Bundle.main.path(forResource: appDelegate.currentLanguage, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}

