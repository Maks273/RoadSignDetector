//
//  RoadSignImageCollectionViewCell.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 08.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class RoadSignImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var signImageView: UIImageView!
    
    //MARK: - Helper
    
    func setupImage(_ image: UIImage?) {
        signImageView.image = image
    }
}
