//
//  RecognizedPageVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 26.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Vision

class RecognizedPageVCHelper {
    
    //MARK: - Variables
    
    var pickedImages: [UIImage] = [] {
        didSet {
            configureDataSource()
        }
    }
    private var dataSource = [UIViewController]()
    
    //MARK: - Helper
    
    func setPickedImages(_ images: [UIImage]) {
        self.pickedImages = images
    }
    
    func viewController(for index: Int) -> UIViewController? {
        return index < dataSource.count ? dataSource[index] : nil
    }
    
    func nextViewController(_ viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = dataSource.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard dataSource.count > nextIndex else {
            return nil
        }
        
        return dataSource[nextIndex]
    }
    
    func previousViewController(_ viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = dataSource.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 && dataSource.count > previousIndex else {
            return nil
        }
        
        return dataSource[previousIndex]
    }
    
    //MARK: - Private methods
    
    private func configureItemViewController(with image: UIImage) -> UIViewController {
        let recognizedItemVC = StorybardService.main.viewController(viewControllerClass: RecognizedItemViewController.self)
        recognizedItemVC.image = image
        return recognizedItemVC
    }
    
    private func configureDataSource() {
        pickedImages.forEach { (image) in
            let viewController = configureItemViewController(with: image)
            dataSource.append(viewController)
        }
    }
    
    
}

