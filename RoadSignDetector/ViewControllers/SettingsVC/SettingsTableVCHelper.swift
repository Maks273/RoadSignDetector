//
//  SettingsTableVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 05.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

enum LegalDocuments {
    case privacyPolicy
    case termsAndCnditions
}

class SettingsTableVCHelper {
    
    //MARK: - Private variables
    
    let headerTitles = ["General".localized(),"Extra".localized()]
    private var menuItemTitles: [[String]] {
        return [generalMenuItem, extraMenuItem]
    }
    private let generalMenuItem = ["Languages".localized(),"Audio".localized()]
    private let extraMenuItem  = ["Contact us".localized(),"Rate the app".localized(),"Privacy Policy".localized(),"Terms & Conditions".localized()]
    private let developerEmail = "paydich28@gmail.com"
    private var selectedIndex: IndexPath?
    
    //MARK: - Helper
    
    func getNumberOfSection() -> Int {
        return headerTitles.count
    }
    
    func getNumberOfRow(at section: Int) -> Int {
        return menuItemTitles[section].count
    }
    
    func getRowHeight(at indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex != nil && indexPath == self.selectedIndex {
            return 188
        }
        return 65
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
    
    func setSelectedIndex(_ selectedIndex: IndexPath) {
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
        return indexPath.section > menuItemTitles.count-1 || indexPath.row > menuItemTitles[indexPath.section].count-1 ? "" : menuItemTitles[indexPath.section][indexPath.row]
    }
    
    func showMoreStatus(at indexPath: IndexPath) -> Bool {
        return indexPath.section == menuItemTitles.count - 1
    }
    
    func getDeveloperEmail() -> String {
        return developerEmail
    }
    
    func loadLegalDocuments(for type: LegalDocuments, completion: @escaping (_ title: String? ,_ context: String?, _ error: Error?) -> Void) {
        let legalDocumentsName = getLegalDocumentsFileName(for: type)
        guard let path =  Bundle.main.path(forResource: legalDocumentsName, ofType: "txt") else {
            return
        }
        do{
            let context = try String(contentsOfFile: path)
            completion(legalDocumentsName,context,nil)
        }catch (let error) {
            completion(nil,nil,error)
        }
    }
    
    //MARK: - Private methods
    
    private func getLegalDocumentsFileName(for type: LegalDocuments) -> String {
        return type == .privacyPolicy ? "Privacy Policy" : "Terms"
    }
   
    
}
