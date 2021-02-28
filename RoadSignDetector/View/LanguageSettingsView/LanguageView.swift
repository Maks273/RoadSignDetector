//
//  LanguageView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class LanguageView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var settingsView: SettingsView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var verticalLine: UIView!
    @IBOutlet var languageButtons: [UIButton]!
    @IBOutlet var indicatorViews: [UIView]!
    @IBOutlet weak var languagesContainerView: UIView!
    @IBOutlet weak var languagesContainerViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    
    private let languages = ["English 🇺🇸".localized(),"Ukrainian 🇺🇦".localized(),"Russian 🇷🇺".localized()]
    private let languageCode = ["en","uk","ru"]
    private var currentLanguageCode: String {
        return UserDefaults.standard.string(forKey: Environment.shared.appLanguageKey) ?? Environment.shared.ukLanguageKey
    }
    
    //MARK: - Initalizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Helper
    
    func configure(isExpanded: Bool) {
        languagesContainerViewBottomConstraint.constant = isExpanded ? -5 : 1
        setupSelectedLanguage()
    }
    
    //MARK: - IBActions
    
    @IBAction func languageBtnPressed(_ sender: UIButton) {
        let language = languageCode[sender.tag]
        saveCurrentLanguage(language: language)
        reloadRootVC()
    }
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LanguageView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        setupStyle()
        fillStackViews()
        configureInidicatorViews(selectedIndex: 0)
    }
    
    //MARK: Swap language
    
    private func saveCurrentLanguage(language: String) {
        UserDefaults.standard.set(language, forKey: Environment.shared.appLanguageKey)
        UserDefaults.standard.synchronize()
        Environment.shared.changeCurrentLocalizeIntoLanguage()
    }
    
    private func reloadRootVC() {
        let tabVC = StorybardService.main.viewController(viewControllerClass: TabBarViewController.self)
        tabVC.langWasChanged = true
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = tabVC
    }
    
    private func setupSelectedLanguage() {
        if let index = languageCode.firstIndex(of: currentLanguageCode) {
            configureInidicatorViews(selectedIndex: index)
        }
    }
    
    //MARK: Style
    
    private func fillStackViews() {
        for (index, button) in languageButtons.enumerated() {
            button.setTitle(languages[index], for: .normal)
        }
    }
    
    private func configureInidicatorViews(selectedIndex: Int) {
        for (index, indicator) in indicatorViews.enumerated() {
            indicator.layer.cornerRadius = indicator.frame.height / 2
            indicator.backgroundColor = selectedIndex == index ? .purple : .darkGray
        }
    }
    
    private func setupStyle() {
        languagesContainerView.setShadow(with: -20)
        verticalLine.defalutVerticalLine(with: [.layerMinXMaxYCorner], cornerRadius: 5)
    }
    
}

