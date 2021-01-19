//
//  DetectionService.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import CoreML
import Vision

class DetectionService {
    
    //MARK: - Variables
    
    private lazy var recognitionRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: _roadSignsModel().model)
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                self.processRecognition(for: request, error: error)
            }
            request.imageCropAndScaleOption = .scaleFit
            return request
        }catch (let error) {
            print("COREML CREATING REQUEST ", error.localizedDescription)
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    //MARK: - Helper
    
    func updateClassification(for image: UIImage) {
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.recognitionRequest])
            }catch(let error) {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Private methods
    
    private func processRecognition(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            
            let recognitionResults = results as! [VNRecognizedObjectObservation]
            NotificationCenter.default.post(name: Notification.Name("recognitionCompleted"), object: nil, userInfo: ["results": recognitionResults])
        }
    }
    
    //MARK: - Private methods
    
    
}
