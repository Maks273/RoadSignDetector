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
import FirebaseStorage
import ProgressHUD

class FirebaseService {
    
    //MARK: - DB names
    private let users = "users"
    private let roadSigns = "roadSigns"
    
    //MARK: User's fields
    private let phoneID = "phoneUUID"
    private let phoneName = "phoneName"
    private let isFavorite = "isFavorite"
    private let history = "history"
    
    //MARK: Storage's fields
    private let images = "images"
    
    //MARK: Storage references
    private let imageStorageReference = Storage.storage().reference().child("images")
    private let soundStrageReference = Storage.storage().reference().child("sounds")
    
    //MARK: - Variables
    
    static let shared = FirebaseService()
    private let userDbReference = Database.database().reference().child("users")
    private let roadSignsReference = Database.database().reference().child("roadSigns")
    
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
    
    func saveHistoryItem(_ item: RoadSign) {
        guard let phoneUID = Environment.shared.currentUser?.phoneUID, let itemID = item.id else {
            return
        }
        
        userDbReference.child(phoneUID).child(history).child(itemID).setValue(item.dict)
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
    
    func toggleFavoriteStatus(with itemID: String, isFavoriteStatus: Bool) {
        guard let currentUserID = Environment.shared.currentUser?.phoneUID else {
            return
        }
        
        userDbReference.child(currentUserID).child(history).child(itemID).updateChildValues([isFavorite:isFavoriteStatus])
    }
    
    //MARK: - Image loading
    
    func loadImages(imageName: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        imageStorageReference.child(imageName).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            completion(data,error)
        }
    }
    
    //MARK: - Loading sound
    
    func loadSound(soundName: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        soundStrageReference.child(soundName).getData(maxSize: 100 * 1024 * 1024) { (data, error) in
            completion(data,error)
        }
    }
    
    //MARK: - Loading road sign
    
    func loadRoadSign(name: String, completion: @escaping (_ roadSign: RoadSign?) -> Void ) {
        roadSignsReference.child(name).observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let roadSign = RoadSign(from: value)
                completion(roadSign)
                return
            }
            completion(nil)
        }
    }

}
