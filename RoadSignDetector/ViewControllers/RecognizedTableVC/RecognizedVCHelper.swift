//
//  RecognizedTableVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//
import UIKit
import Vision
import ProgressHUD

class RecognizedVCHelper {
    
    //MARK: - Variables
    
    private var recognizedItems = [RecognizedItem]()
    private var model = [RoadSign]()
    private var recognizedResults = [VNRecognizedObjectObservation]() {
        didSet {
            loadDetectedItems()
        }
    }
    
    var modelWasAdded: (() -> Void)?
    
    //MARK: - Helper
    
    func setRecognizedResults(_ results: [VNRecognizedObjectObservation]) {
        self.recognizedResults = results
    }
    
    func getNumberOfRows() -> Int {
        recognizedItems.count
    }
    
    func getBoundsBoxes() -> [CGRect] {
        return recognizedResults.map({$0.boundingBox})
    }
    
    func getModel(for index: Int) -> RecognizedItem? {
        return canGetModel(for: index) ? recognizedItems[index] : nil
    }
    
    func isNoDataLabelVisible() -> Bool {
        return recognizedItems.isEmpty
    }
    
    func loadDetectedItems() {
        for result in recognizedResults {
            if canLoadItem(result) {
                loadItem(by: result.labels[0])
            }
        }
    }
    
    //MARK: - Private methods
    
    private func canGetModel(for index: Int) -> Bool {
        return index < recognizedItems.count
    }
    
    //MARK: Configure recognized model
    private func configureRecoginzedModel(with roadSign: RoadSign, item: VNClassificationObservation) {
        let convertedPercentValue = convertPercentValue(from: item.confidence.magnitude)
        let recognizedItem = RecognizedItem(precent: convertedPercentValue, roadSign: roadSign)
        recognizedItems.append(recognizedItem)
        FirebaseService.shared.saveHistoryItem(roadSign)
        modelWasAdded?()
    }
    
    private func convertPercentValue(from value: Float) -> String {
        return String(value * 100).prefix(5).description
    }
    
    //MARK: Loading item from server
    
    private func loadItem(by item: VNClassificationObservation) {
        FirebaseService.shared.loadRoadSign(name: item.identifier) { [weak self] (roadSign) in
            if let roadSign = roadSign {
                self?.configureRecoginzedModel(with: roadSign, item: item)
            }
        }
    }
    
    private func canLoadItem(_ item: VNRecognizedObjectObservation) -> Bool {
        return !item.labels.isEmpty
    }
    
}
