//
//  ReachabilityService.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 10.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Reachability

class NetworkService {
    
    //MARK: - Variables
    
    private var reachability: Reachability!
    
    static let shared = NetworkService()
    
    //MARK: - Initalizer/Deinitalizer
    
    deinit {
        stopNotifier()
    }
    
    //MARK: - Helper
    
    func stopNotifier() {
        if reachability.connection != .unavailable {
            reachability.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        }
    }
    
    func startObserving() {
       // initReachability()
    }
    
    //MARK: - Private methods
    
    private func initReachability() {
        do {
            reachability = try Reachability()
            try reachability.startNotifier()
            addObserver()
        }catch(let error) {
            print("Error with starting reachability = \(error.localizedDescription)")
        }
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: nil)
    }
    
    @objc private func networkStatusChanged(_ notification: Notification) {
        guard let reachabilityObject = notification.object as? Reachability else {
            return
        }
        
        let reachabilityStatus = reachabilityObject.connection
        Environment.shared.currentConnectionStatus = reachabilityStatus
    }
}
