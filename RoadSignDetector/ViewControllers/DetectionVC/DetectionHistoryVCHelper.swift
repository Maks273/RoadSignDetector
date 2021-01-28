//
//  DetectionHistoryVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 06.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import ProgressHUD

class DetectionHistoryVCHelper {
    
    //MARK: - Variables
    
    private let favoriteHistoryIndex = 1
    private let allHistoryIndex = 0
    private let isFavoriteImageName = "filledStar"
    private let unfavoriteImageName = "unfilledStar"
    private var tempModel: [[RoadSign]]?
    private var filterCurrentType: HistoryType?
    
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
    
    init() {
        setupModel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currentUserWasIdenfied, object: nil)
        NotificationCenter.default.removeObserver(self,name: .historyWasChanged, object: nil)
    }
    
    //MARK: - Helper
    
    func getModel(for index: Int) -> RoadSign? {
        canGetModel(for: index) ? model[getCurrentModelIndex()][index] : nil
    }
    
    func getNumberOfRows() -> Int {
        return model.isEmpty ? 0 : model[getCurrentModelIndex()].count
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
        
        FirebaseService.shared.removeHistoryItem(by: itemID, isLastItem: model[allHistoryIndex].count == 1)
    }
    
    func getFavoriteImageName(for index: Int) -> String {
        guard let model = getModel(for: index) else {
            return unfavoriteImageName
        }
        return model.isFavorite ? isFavoriteImageName : unfavoriteImageName
    }
    
    func handleFavoriteStatus(for index: Int) {
        guard let model = getModel(for: index), let modelID = model.id else {
            return
        }
        
        FirebaseService.shared.toggleFavoriteStatus(with: modelID, isFavoriteStatus: !model.isFavorite)
    }
    
    func isNoDataLabelVisible() -> Bool {
        return getNumberOfRows() == 0
    }
    
    func loadHistoryData() {
        guard let userID = Environment.shared.currentUser?.phoneUID else {
            return
        }
        
        FirebaseService.shared.loadHistoryItems(for: userID)
    }
    
    func filterHistoryModel(with searchText: String) {
   
        let filtredModel = model[getCurrentModelIndex()].compactMap { (item) -> RoadSign? in
            return item.localizationInfo?.title?.lowercased().contains(searchText.lowercased()) ?? false ? item : nil
        }
        model[getCurrentModelIndex()] = filtredModel
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            filtredModel.isEmpty ? ProgressHUD.showError("Can't find any item by searching text.".localized(), image: nil, interaction: true) : ProgressHUD.showSuccess()
            
        }
    }
    
    func resetFilterModel() {
        if let tempModel = tempModel {
            model[getCurrentModelIndex()] = tempModel[getCurrentModelIndex()]
        }
    }
    
    func showLoadingSpinner() {
        if Environment.shared.selectedTabIndex == 0 {
            ProgressHUD.show()
        }
    }
    
    //MARK: - Private methods
    
    private func setupModel() {
        if let currentUser = Environment.shared.currentUser {
            model[allHistoryIndex] = currentUser.history.all
            model[favoriteHistoryIndex] = currentUser.history.all.compactMap({ (roadSign) -> RoadSign? in
                return roadSign.isFavorite ? roadSign : nil
            })
            tempModel = model
        }
    }
    
    private func getCurrentModelIndex() -> Int {
        return currentType == .favorite ? favoriteHistoryIndex : allHistoryIndex
    }
    
    private func canGetModel(for index: Int) -> Bool {
        return index < model[currentType == .favorite ? favoriteHistoryIndex : allHistoryIndex].count
    }
    
    //MARK: objc methods
    
    @objc private func currentUserDidChange() {
        setupModel()
    }
    
    @objc private func historySourceWasChanged(_ notification: Notification) {
        print("historySourceWasChanged".capitalized)
        setupModel()
    }
    
}
