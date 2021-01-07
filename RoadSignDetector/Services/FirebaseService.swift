//
//  FirebaseService.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 05.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class FirebaseService {
    
    //MARK: - DB names
    private let users = "users"
    private let roadSigns = "roadSigns"
    
    //MARK: User's fields
    
    private let phoneID = "phoneUUID"
    private let phoneName = "phoneName"
    private let all = "all"
    private let favorite = "favorite"
    private let history = "history"
    
    //MARK: - Variables
    
    static let shared = FirebaseService()
    private let userDbReference = Database.database().reference().child("users")
    
    //MARK: - Initalizers
    
    private init(){}
    
    //MARK: - Auth method
    
    func handleAuthorization(completion: @escaping (_ currentUser: User?) -> Void) {
        guard let phoneUID = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        userDbReference.child(phoneUID).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if snapshot.exists() {
                self?.loadCurrentUser(for: phoneUID, completion: { (currentUser) in
                    completion(currentUser)
                })
            }else{
                self?.registerUserDevice(with: phoneUID)
            }
            self?.loadHistoryItems(for: phoneUID)
        }
    }
    
    private func loadCurrentUser(for phoneUID: String, completion: @escaping (_ currentUser: User?) -> Void) {
        userDbReference.child(phoneUID).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let user = User(from: value)
                NSLog("USER = \(value)")
                completion(user)
                return
            }
            completion(nil)
        }
        
    }
    
    private func registerUserDevice(with phoneUID: String) {
        let currentUser = User(phoneName: UIDevice.current.name, phoneUID: phoneUID, history: History())
        userDbReference.child(phoneUID).setValue(currentUser.userDictionary)
    }
    
    //MARK: - Historie's types observers
    
    func decodeDataToRoadSignArray(from dicts: NSDictionary) -> [RoadSign] {
        var decodedArray = [RoadSign]()
        
        for item in dicts {
            if let itemValueDict = item.value as? NSDictionary {
                let decodedItem = RoadSign(from: itemValueDict)
                decodedArray.append(decodedItem)
            }
        }
        return decodedArray
    }
    
    func loadHistoryItems(for phoneID: String) {
        userDbReference.child(phoneID).child(history).observe(.value) { [weak self] (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let decodedHistoryData = self?.decodeDataToRoadSignArray(from: value) {
                    self?.fillHistoryData(data: decodedHistoryData)
                    self?.postHistoryTypeNotification()
                }
            }
        }
    }
    
    private func fillHistoryData(data: [RoadSign]) {
        Environment.shared.currentUser?.history?.all = data
    }
    
    private func postHistoryTypeNotification() {
        NotificationCenter.default.post(name: .historyWasChanged, object: nil)
    }
    
    //MARK: - Make star/unstar and delete historie's item
    
    func removeHistoryItem(by id: String) {
        guard let currentUserID = Environment.shared.currentUser?.phoneUID else {
            return
        }
        userDbReference.child(currentUserID).child(history).child(id).removeValue { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}
