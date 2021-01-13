//
//  ScanningVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 09.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Vision

class ScanningVCHelper {
    
    //MARK: - Variables
    
    private var recognizedResults = [VNRecognizedObjectObservation]()
    
    //MARK:  - Initalizer/Deinitalizer
  

    
    //MARK: - Helper
    
    
    
    //MARK: - Private methods
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(recognizingCompleted(_:)), name: Notification.Name("recognitionCompleted"), object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("recognitionCompleted"), object: nil)
    
    }
    
    @objc private func recognizingCompleted(_ notification: Notification) {
        guard let result = notification.userInfo?["results"] as? [VNRecognizedObjectObservation] else {
            return
        }
        
        recognizedResults = result
        print("JUST GOT = \(result)")
    }
     
}
