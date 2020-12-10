//
//  StoryboardService.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

enum StorybardService: String {
    
    case main = "Main"
    
    private var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let VC = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("Error with getting view controller \(storyboardID)")
        }
        return VC
    }
}
