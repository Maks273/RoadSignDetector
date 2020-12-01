//
//  SettingsViewModel.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 29.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class SettingsViewModel {
    
    private let generalMenuItem = ["Languages","Audio"]
    private let extraMenuItem  = ["Contact us","Privacy policy","Rate the app"]
    let headerTitles = ["General","Extra"]
    private var selectedIndex: IndexPath?
    
    var menuItemTitles: [[String]] {
        return [generalMenuItem,extraMenuItem]
    }
    
    func getNumberOfSection() -> Int {
        return headerTitles.count
    }
    
    func getNumberOfRow(at section: Int) -> Int {
        return menuItemTitles[section].count
    }
    
    func getRowHeight(at indexPath: IndexPath) -> CGFloat {
        if selectedIndex != nil && indexPath == selectedIndex {
            return 120
        }
        return 55
    }
    
    func defineCellPosition(at indexPath: IndexPath) -> CellPosition {
        if indexPath.row == 0 {
            return .first
        }else if indexPath.row == menuItemTitles[indexPath.section].count - 1 {
            return .last
        }else {
            return .intermediate
        }
    }
    
    func canExpand(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func setSelectedIndex(_ selectedIndex: IndexPath){
        self.selectedIndex = selectedIndex == self.selectedIndex ? nil : selectedIndex
    }
    
    func getSelectedIndex() -> IndexPath? {
        return selectedIndex
    }
    
    func defineExpandViewForCell(at indexPath: IndexPath) -> CellType {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return .language
        case IndexPath(row: 1, section: 0):
            return .audio
        default:
            return .language
        }
    }
    
    func getCellTitle(at indexPath: IndexPath) -> String {
        return menuItemTitles[indexPath.section][indexPath.row]
    }
    
    func showMoreStatus(at indexPath: IndexPath) -> Bool{
        return indexPath.section == menuItemTitles.count - 1
    }
}
