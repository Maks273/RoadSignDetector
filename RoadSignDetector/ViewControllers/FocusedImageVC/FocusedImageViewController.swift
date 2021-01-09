//
//  FocusedImageViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 09.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class FocusedImageViewController: UIViewController {
    
    //MARK: - Variables
    var image: UIImage? {
        didSet {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        }
    }
    private let imageView = UIImageView()
    private let distanceToView: CGFloat = 50
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisualEffectView()
        setupImageViewConstraints()
    }
    
    //MARK: - Private methods
    
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        self.view.addConstraints([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: distanceToView),
            imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: distanceToView),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: distanceToView),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -distanceToView)
        ])
    }
    
    private func setupVisualEffectView() {
        let visualEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
    }
    

}
