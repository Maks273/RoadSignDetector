//
//  RecognizedPageViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 26.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import ProgressHUD
import Vision

class RecognizedViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var headerView: RecognizeHeader!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Variables
    
    var pickedImages: [UIImage] = []
    private var recognizedPageViewController: RecognizedPageViewController?
    
    //MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderView()
    }
    
    //MARK: - Helper
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier, segueID == "recognizedPageVC" {
            if let recognizedPageViewController = segue.destination as? RecognizedPageViewController {
                self.recognizedPageViewController = recognizedPageViewController
                recognizedPageViewController.recognizedPageVCHelper.setPickedImages(pickedImages)
            }
        }
    }
    
    
    //MARK: - Private methods
    
        //MARK: nav bar
    
    private func configureHeaderView() {
        headerView.setupTitle("Recognized")
        headerView.delegate = self
    }
    
    @objc private func backBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension RecognizedViewController: RecognizeHeaderDelegate {
    func popToViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
