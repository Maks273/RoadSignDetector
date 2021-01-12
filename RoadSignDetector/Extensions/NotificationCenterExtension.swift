//
//  NotificationCenterExtension.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 11.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Reachability

extension NotificationCenter {
    func addNetworkObserver(in viewController: UIViewController) {
        addObserver(viewController, selector: #selector(UIViewController.connectionWasChanged), name: .currentConnectionStatusWasChanged, object: nil)
        viewController.connectionWasChanged()
    }
    
    func removeNetworkObserver(in viewController: UIViewController) {
        removeObserver(viewController, name: .currentConnectionStatusWasChanged, object: nil)
        viewController.animateClearing()
    }
}
