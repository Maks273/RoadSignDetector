//
//  ScaningViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class ScanningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = AudioView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        self.view.addConstraints([
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        view.addConstraints([
            view.heightAnchor.constraint(equalToConstant: 300),
            view.widthAnchor.constraint(equalToConstant: 300)
        ])
        // Do any additional setup after loading the view.
    }
    

}
