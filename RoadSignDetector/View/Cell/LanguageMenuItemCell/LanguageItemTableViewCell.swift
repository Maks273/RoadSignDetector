//
//  LanguageItemTableViewCell.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 01.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class LanguageItemTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var separateLineView: UIView!
    
    //MARK: - Variables
    
    var languageCode: String? {
        didSet{
            let currentLanguage = UserDefaults.standard.string(forKey: Environment.shared.appLanguageKey)
            selectButton.backgroundColor = currentLanguage == languageCode ? .purple : .gray
        }
    }

    weak var delegate: LanguageProtocol!
    
    //MARK: - Overrided funcs
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - IBActions
    
    @IBAction func selectBtnWasPressed(_ sender: Any) {
        saveCurrentLanguage()
        reloadRootVC()
        delegate.reloadTableView()
    }
    
    //MARK: - Helper
    
    func cofigureCell(text: String, separateLineStatus: Bool){
        selectButton.layer.cornerRadius = selectButton.bounds.width/2
        separateLineView.isHidden = separateLineStatus
        titleLabel.text = text
    }
    
    //MARK: - Private methods
    
    private func saveCurrentLanguage() {
        UserDefaults.standard.set(languageCode, forKey: Environment.shared.appLanguageKey)
        UserDefaults.standard.synchronize()
        Environment.shared.changeCurrentLocalizeIntoLanguage()
    }
    
    private func reloadRootVC() {
        let tabVC = StorybardService.main.viewController(viewControllerClass: TabBarViewController.self)
        tabVC.langWasChanged = true
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = tabVC
    }
}
