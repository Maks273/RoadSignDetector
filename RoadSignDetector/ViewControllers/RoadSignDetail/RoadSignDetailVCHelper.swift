//
//  RoadSignDetailVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 08.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class RoadSignDetailVCHelper {
    
    //MARK: - Variables
    
    private var model: RoadSign! {
        didSet {
            loadImages {
                self.didLoadImages?()
            }
        }
    }
    private var images = [UIImage?]()
    var didLoadImages: (() -> Void)?
    
    //MARK: - Helper
    
    func getNumberOfItems() -> Int {
        return images.count
    }
    
    func getImage(for index: Int) -> UIImage? {
        return canGetImage(at: index) ? images[index] : UIImage()
    }
    
    func setModel(_ model: RoadSign) {
        self.model = model
    }
    
    func getModel() -> RoadSign {
        return model
    }
    
    //MARK: - Private methods
    
    private func loadImages(completion: @escaping () -> Void) {
        guard model != nil, !model.images.isEmpty else {
            return
        }
    
        for imageName in self.model.images {
            FirebaseService.shared.loadImages(imageName: imageName) { (data, error) in
                if error == nil {
                    let image = UIImage(data: data!)
                    self.images.append(image)
                    completion()
                }
            }
        }
    }
    
    private func canGetImage(at index: Int) -> Bool {
        return index < model.images.count
    }
    
}
