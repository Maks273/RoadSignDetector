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

struct SettingsCellModel {
    var title: String
    var isExpanded: Bool
    var position: CellPosition
    var showMoreVisible: Bool
}

class SettingsTableVCHelper {
    
    //MARK: - Private variables
    
    let headerTitles = ["General".localized(),"Extra".localized()]
    private lazy var menuItemTitles: [[SettingsCellModel]] = {
       return [generalMenuItem, extraMenuItem]
    }()
    private let generalMenuItem = [ SettingsCellModel(title: "Languages".localized(), isExpanded: false, position: .first, showMoreVisible: true),
                                    SettingsCellModel(title: "Audio".localized(), isExpanded: false, position: .last, showMoreVisible: true)]
    
    private let extraMenuItem  = [SettingsCellModel(title: "Contact us".localized(), isExpanded: false, position: .first, showMoreVisible: false),
                                  SettingsCellModel(title: "Rate the app".localized(), isExpanded: false, position: .intermediate, showMoreVisible: false),
                                  SettingsCellModel(title: "Privacy Policy".localized(), isExpanded: false, position: .intermediate, showMoreVisible: false),
                                  SettingsCellModel(title: "Terms & Conditions".localized(), isExpanded: false, position: .last, showMoreVisible: false)]
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
        if menuItemTitles[indexPath.section][indexPath.row].isExpanded {
            return 200
        }
        return 65
    }
    
    func canExpand(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func getCellTitle(at indexPath: IndexPath) -> String {
        return indexPath.section > menuItemTitles.count-1 || indexPath.row > menuItemTitles[indexPath.section].count-1 ? "" : menuItemTitles[indexPath.section][indexPath.row].title
    }
    
    func getDeveloperEmail() -> String {
        return developerEmail
    }
    
    func loadLegalDocuments(for type: LegalDocuments, completion: @escaping (_ title: String? ,_ context: String?, _ errorMessage: String?) -> Void) {
        let legalDocumentsName = getLegalDocumentsFileName(for: type)
        guard let path =  Bundle.main.path(forResource: legalDocumentsName, ofType: "txt") else {
            completion(nil, nil, "Invalid path to \(legalDocumentsName)")
            return
        }
        do{
            let context = try String(contentsOfFile: path)
            completion(legalDocumentsName,context,nil)
        }catch (let error) {
            completion(nil,nil,error.localizedDescription)
        }
    }
    
    func changeExpandedStatus(at indexPath: IndexPath) {
        menuItemTitles[indexPath.section][indexPath.row].isExpanded.toggle()
    }
    
    func getModel(for indexPath: IndexPath) -> SettingsCellModel? {
        return indexPath.section > menuItemTitles.count-1 || indexPath.row > menuItemTitles[indexPath.section].count-1 ? nil : menuItemTitles[indexPath.section][indexPath.row]
    }
    
    func configureCell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! LanguageSettingsTableViewCell
            if let model = getModel(for: indexPath) {
                cell.configure(with: model)
            }
            return cell
        }else if indexPath == IndexPath(row: 1, section: 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath) as! AudioSettingsTableViewCell
            if let model = getModel(for: indexPath) {
                cell.configure(with: model)
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
            if let model = getModel(for: indexPath) {
                cell.configure(with: model)
            }
            return cell
        }
    }
    
    //MARK: - Private methods
    
    private func getLegalDocumentsFileName(for type: LegalDocuments) -> String {
        return type == .privacyPolicy ? "Privacy Policy" : "Terms & Conditions"
    }
    
    
}
