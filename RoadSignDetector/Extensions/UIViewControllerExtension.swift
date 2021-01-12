//
//  UIViewControllerExtension.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit
import Reachability

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    //MARK: - Offline alert
    
     func animateClearing() {
        if isOfflineAlert() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                UIView.animate(withDuration: 1) {
                    self.view.subviews.last?.alpha = 0
                } completion: { (finished) in
                    if finished {
                        self.clearOfflineAlert()
                    }
                }
            }
        }
    }
    
    private func clearOfflineAlert() {
        self.view.subviews.last?.removeFromSuperview()
    }
    
    private func isOfflineAlert() -> Bool {
        return self.view.subviews.last as? OfflineAlert != nil
    }
    
    private func showOfflineAlert() {
        let offlineView = OfflineAlert()
        offlineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(offlineView)
        
        offlineView.addConstraints([
            offlineView.heightAnchor.constraint(equalToConstant: 160),
            offlineView.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        self.view.addConstraints([
            offlineView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            offlineView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
        ])
        
        offlineView.draw(offlineView.frame)
    }
    
   @objc func connectionWasChanged() {
        if Environment.shared.currentConnectionStatus != nil {
            switch Environment.shared.currentConnectionStatus {
            case .cellular,.wifi:
                animateClearing()
            default:
                showOfflineAlert()
            }
        }
    }
    
}
