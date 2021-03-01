//
//  RecognizedPageViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 26.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Vision

class RecognizedPageViewController: UIPageViewController {
    
    //MARK: - Variables
    
    let recognizedPageVCHelper = RecognizedPageVCHelper()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageVC()
        setupInitialViewController()
    }
    
    
    //MARK: - Private methods
    
    private func configurePageVC() {
        self.dataSource = self
    }
    
    private func setupInitialViewController() {
        if let viewController = recognizedPageVCHelper.viewController(for: 0) {
            setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
}

//MARK: - UIPageViewControllerDataSource

extension RecognizedPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return recognizedPageVCHelper.previousViewController(viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return recognizedPageVCHelper.nextViewController(viewController)
    }
}
