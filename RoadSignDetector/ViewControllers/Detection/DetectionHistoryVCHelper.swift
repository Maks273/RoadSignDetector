//
//  DetectionHistoryVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 06.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class DetectionHistoryVCHelper {
    
    //MARK: - Variables
    
    private let favoriteHistoryIndex = 1
    private let allHistoryIndex = 0
    private let isFavoriteImageName = "filledStar"
    private let unfavoriteImageName = "unfilledStar"
    
    private var model = [[RoadSign]](repeating: [RoadSign](), count: 2){
        didSet{
            modelWasAdded?()
        }
    }
    
    private var currentType: HistoryType = .all {
        didSet{
            setupModel()
            modelWasAdded?()
        }
    }
    
    var modelWasAdded: (() -> Void)?
    
    
    //MARK: - Initalizer/Deinitalizer
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currentUserWasIdenfied, object: nil)
        NotificationCenter.default.removeObserver(self,name: .historyWasChanged, object: nil)
    }
    
    //MARK: - Helper
    
    func getModel(for index: Int) -> RoadSign? {
        canGetModel(for: index) ? model[currentType == .favorite ? favoriteHistoryIndex : allHistoryIndex][index] : nil
    }
    
    func getNumberOfRows() -> Int {
        return model.isEmpty ? 0 : model[currentType == .favorite ? favoriteHistoryIndex : allHistoryIndex].count
    }
    
    func observeCurrentUser() {
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidChange), name: .currentUserWasIdenfied, object: nil)
        observeChangesInHistory()
    }
    
    func observeChangesInHistory() {
        NotificationCenter.default.addObserver(self, selector: #selector(historySourceWasChanged), name: .historyWasChanged, object: nil)
    }
    
    func setCurrentHistoryType(for tag: Int) {
        currentType = tag == favoriteHistoryIndex ? .favorite : .all
    }
    
    func removeHistoryItem(for index: Int) {
        guard let itemID = model[allHistoryIndex][index].id else {
            return
        }
        FirebaseService.shared.removeHistoryItem(by: itemID)
    }
    
    func getFavoriteImageName(for index: Int) -> String {
        guard let model = getModel(for: index) else {
            return unfavoriteImageName
        }
        return model.isFavorite ? isFavoriteImageName : unfavoriteImageName
    }
    
    //MARK: - Private methods
    
    private func setupModel() {
        if let currentUser = Environment.shared.currentUser {
            model[allHistoryIndex] = currentUser.history!.all
            model[favoriteHistoryIndex] = currentUser.history!.all.compactMap({ (roadSign) -> RoadSign? in
                return roadSign.isFavorite ? roadSign : nil
            })
        }
    }
    
    //MARK: objc methods
    
    @objc private func currentUserDidChange() {
        setupModel()
    }
    
    @objc private func historySourceWasChanged(_ notification: Notification) {
        print("historySourceWasChanged".capitalized)
        setupModel()
    }
    
    private func canGetModel(for index: Int) -> Bool {
        return index < model[currentType == .favorite ? favoriteHistoryIndex : allHistoryIndex].count
    }
    
}
