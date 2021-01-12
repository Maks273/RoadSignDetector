//
//  ViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit
import SOTabBar
import ProgressHUD

enum BarItems {
    case settings
    case history
    case scannig
    
    func values() -> (String,String) {
        switch self {
        case .settings: return ("Settings".localized(),"gear")
        case .history: return ("History".localized(),"clock")
        case .scannig: return ("Camera".localized(), "camera.viewfinder")
        }
    }
}

class TabBarViewController: SOTabBarController {
    
    //MARK: - Variables
    
    private var previoussVC: UIViewController?

    //MARK: - Life cycles
    
    override func loadView() {
        super.loadView()
        configureBarStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupBarItems()
    }

    
    //MARK: - Private methods
    
    private func setupBarItems(){
        let settingsVC = StorybardService.main.viewController(viewControllerClass: SettingsTableViewController.self)
        let historyVC = StorybardService.main.viewController(viewControllerClass: DetectionHistoryTableViewController.self)
        let scaningVC = StorybardService.main.viewController(viewControllerClass: ScanningViewController.self)
        
        settingsVC.tabBarItem = configureBarItem(type: .settings, selectedColor: .white, unselectedColor: .purple)
        historyVC.tabBarItem = configureBarItem(type: .history, selectedColor: .white, unselectedColor: .purple)
        scaningVC.tabBarItem = configureBarItem(type: .scannig, selectedColor: .white, unselectedColor: .purple)
        
        viewControllers = [historyVC,scaningVC,settingsVC]
    }
    
    private func configureImage(name: String, with color: UIColor) -> UIImage? {
        let image = UIImage(systemName: name)?.withRenderingMode(.alwaysTemplate)
        let render = UIGraphicsImageRenderer(size: image?.size ?? CGSize(width: 0, height: 0))
        
        let renderedImage = render.image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            image?.draw(at: .zero)
        }
        return renderedImage
    }
    
    private func configureBarItem(type: BarItems, selectedColor: UIColor, unselectedColor: UIColor) -> UITabBarItem {
        let imageName = type.values().1
        let title = type.values().0
        
        let unselectedImage = configureImage(name: imageName, with: unselectedColor)
        let selectedImage = configureImage(name: imageName, with: selectedColor)
        
        return UITabBarItem(title: title, image: unselectedImage, selectedImage: selectedImage)
    }
    
    private func configureBarStyle(){
        SOTabBarSetting.tabBarTintColor = .purple
        SOTabBarSetting.tabBarSizeSelectedImage = 30
        SOTabBarSetting.tabBarSizeImage = 35
    }
    
    private func setupInitfialPreviousVC() {
        if viewControllers.count > 2 {
            previoussVC = viewControllers[1]
        }
    }

}

extension TabBarViewController: SOTabBarControllerDelegate {
    func tabBarController(_ tabBarController: SOTabBarController, didSelect viewController: UIViewController) {
        Environment.shared.selectedTabIndex = ((viewController as? DetectionHistoryTableViewController) != nil) ? 0 : 1
        previoussVC?.viewWillDisappear(true)
        previoussVC = viewController
        ProgressHUD.dismiss()
    }
}

