//
//  RecognizedTableVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Vision

class RecognizedVCHelper {
    
    //MARK: - Variables
    
    private var model = [RoadSign]()
    private var recognizedResults = [VNRecognizedObjectObservation]()
    
    //MARK: - Helper
    
    func setRecognizedResults(_ results: [VNRecognizedObjectObservation]) {
        self.recognizedResults = results
    }
    
    func getNumberOfRows() -> Int {
        recognizedResults.count
    }
    
    func getBoundsBoxes() -> [CGRect] {
        return recognizedResults.map({$0.boundingBox})
    }
    
    //MARK: - Private methods
    
}
