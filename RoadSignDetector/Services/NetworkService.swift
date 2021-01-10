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
    
    //MARK: - Initalizer/Deinitalizer
    
    init() {
        do {
            reachability = try Reachability()
            addObserver()
            try reachability.startNotifier()
        }catch {
            
        }
    }
    
    deinit {
        stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
    
    //MARK: - Helper
    
    func stopNotifier() {
        if reachability.connection != .unavailable {
            reachability.stopNotifier()
        }
    }
    
    //MARK: - Private methods
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .reachabilityChanged, object: nil)
    }
    
    @objc private func networkStatusChanged(_ notification: Notification) {
        guard let reachabilityObject = notification.object as? Reachability else {
            return
        }
        
        let reachabilityStatus = reachabilityObject.connection
        
        switch reachabilityStatus {
        case .cellular, .wifi:
            print("CELLULAR AND WIFI")
        default:
            print("UNAVAILABLE")
        }
        print("IT WORKS")
    }
    
    private func showOfflineAlert() {
        
    }
}
