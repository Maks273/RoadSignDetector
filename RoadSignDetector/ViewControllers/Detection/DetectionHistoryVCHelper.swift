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
    
    private var model = [[RoadSign]](repeating: [RoadSign](), count: 2){
        didSet{
            modelWasAdded?()
        }
    }
    
    var modelWasAdded: (() -> Void)?
    
    private var currentType: HistoryType = .all {
        didSet{
            modelWasAdded?()
        }
    }
    
    //MARK: - Initalizer/Deinitalizer
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currentUserWasIdenfied, object: nil)
    }
    
    //MARK: - Helper
    
    func getModel(for index: Int) -> RoadSign? {
        canGetModel(for: index) ? model[currentType == .favorite ? 1 : 0][index] : nil
    }
    
    func getNumberOfRows() -> Int {
        return model.isEmpty ? 0 : model[currentType == .favorite ? 1 : 0].count
    }
    
    func changeModelSource(for tag: Int) {
        setupModel(for: tag == 1 ? .favorite : .all)
    }
    
    func setupModel(for type: HistoryType) {
        if let currentUser = Environment.shared.currentUser {
            switch type {
            case .favorite:
                model[1] = currentUser.history!.favorite
            default:
                model[0] = currentUser.history!.all
            }
        }
    }
    
    func observeCurrentUser() {
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidChange), name: .currentUserWasIdenfied, object: nil)
        observeChangesInHistory()
    }
    
    func observeChangesInHistory() {
        NotificationCenter.default.addObserver(self, selector: #selector(historySourceWasChanged), name: .allHistoryWasChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(historySourceWasChanged), name: .favoriteHistoryWasChanged, object: nil)
    }
    
    func setCurrentHistoryType(for tag: Int) {
        currentType = tag == 1 ? .favorite : .all
    }
    
    //MARK: - Private methods
    
    @objc private func currentUserDidChange() {
        setupModel(for: .all)
    }
    
    @objc private func historySourceWasChanged(_ notification: Notification) {
        if notification.name == .allHistoryWasChanged {
            setupModel(for: .all)
        }else if notification.name == .favoriteHistoryWasChanged {
            setupModel(for: .favorite)
        }
    }
    
    @objc private func favoriteHistoryWasChanged() {
        setupModel(for: .favorite)
    }
    
    private func canGetModel(for index: Int) -> Bool {
        return index < model[currentType == .favorite ? 1 : 0].count
    }
    
}
