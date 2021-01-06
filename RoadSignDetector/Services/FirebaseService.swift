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
            self?.loadHistoryTypeItems(for: phoneUID, for: .favorite)
            self?.loadHistoryTypeItems(for: phoneUID, for: .all)
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
    
    func loadHistoryTypeItems(for phoneID: String, for historyType: HistoryType) {
        let child = historyType == .all ? all : favorite
        userDbReference.child(phoneID).child(history).child(child).observe(.value) { [weak self] (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let decodedHistoryTypeData = self?.decodeDataToRoadSignArray(from: value) {
                    self?.pushHistoryTypeData(for: historyType, data: decodedHistoryTypeData)
                    self?.postHistoryTypeNotification(for: historyType)
                }
            }
        }
    }
    
    private func pushHistoryTypeData(for type: HistoryType, data: [RoadSign]) {
        switch type {
        case .favorite:
            Environment.shared.currentUser?.history?.favorite = data
        default:
            Environment.shared.currentUser?.history?.all = data
        }
    }
    
    private func postHistoryTypeNotification(for type: HistoryType) {
        switch type {
        case .favorite:
            NotificationCenter.default.post(name: .favoriteHistoryWasChanged, object: nil)
        default:
            NotificationCenter.default.post(name: .allHistoryWasChanged, object: nil)
        }
    }
    
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
    
}
