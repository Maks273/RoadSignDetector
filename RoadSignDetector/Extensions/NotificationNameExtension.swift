//
//  NotificationNameExtension.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 06.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit


extension NSNotification.Name {
    static let currentUserWasIdenfied = Notification.Name("currentUserWasIdenfied")
    static let historyWasChanged = Notification.Name("historyWasChanged")
    static let currentConnectionStatusWasChanged = Notification.Name("currentConnectionStatusWasChanged")
}
