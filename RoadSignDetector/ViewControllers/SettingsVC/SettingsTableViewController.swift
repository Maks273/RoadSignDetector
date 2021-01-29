//
//  SettingsTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit
import MessageUI

protocol SettingProtocol: class {
    func getCellIndexPath(for cell: UITableViewCell) -> IndexPath
    func increaseCellSize(at indexPath: IndexPath)
    func getTypeOfExpandedCell(at indexPath: IndexPath) -> CellType
    func addChildVC(_ viewController: UIViewController)
    func setExpandedCellIndexPath(_ indexPath: IndexPath?)
    func isExpandedIndexPath() -> Bool
}

class SettingsTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerLabel: UILabel!
    
    //MARK: - Variables
    private let settingsHelper = SettingsTableVCHelper()
    private let cellIdentifire = "settingCell"
    private var expandedCellIndexPath: IndexPath?
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = headerLabel.text?.localized()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifire)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addNetworkObserver(in: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeNetworkObserver(in: self)
    }
    
    
    //MARK: - Helper
    
    private func configureHeaderLabel(with title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont(name: "AvenirNext-Medium", size: 27)
        return label
    }
    
    private func configureHeaderView(with title: String) -> UIView {
        let view = UIView()
        let headerLabel = configureHeaderLabel(with: title)
        view.addSubview(headerLabel)
        
        view.addConstraints([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            headerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5)
        ])
        
        return view
    }
    
    private func openEmailApp() {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([settingsHelper.getDeveloperEmail()])
            present(mailVC, animated: true, completion: nil)
        }
    }
    
    private func showLegalDocuments(for type: LegalDocuments) {
        settingsHelper.loadLegalDocuments(for: type) { [weak self] (title,context, errorMessage) in
            self?.showLegalDocsVC(with: context, title: title, errorMessage: errorMessage)
        }
    }
    
    private func showLegalDocsVC(with documentContext: String?, title: String?, errorMessage: String?) {
        let legalDocsVC = StorybardService.main.viewController(viewControllerClass: LegalDocsViewController.self)
        legalDocsVC.modalPresentationStyle = .fullScreen
        legalDocsVC.headerTitle = title
        legalDocsVC.documentContext = documentContext
        legalDocsVC.errorMessage = errorMessage
        present(legalDocsVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsHelper.getNumberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsHelper.getNumberOfRow(at: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingsHelper.getRowHeight(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! SettingTableViewCell
        cell.delegate = self
        let title = settingsHelper.getCellTitle(at: indexPath)
        let cellPosition = settingsHelper.defineCellPosition(at: indexPath)
        let showMore = settingsHelper.showMoreStatus(at: indexPath)
        cell.configure(text: title, for: cellPosition, showMoreVisible: showMore, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = settingsHelper.headerTitles[section]
        return configureHeaderView(with: headerTitle)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !settingsHelper.canExpand(indexPath){
            tableView.deselectRow(at: indexPath, animated: true)
            switch indexPath.row {
            case 0:
                self.openEmailApp()
            case 2:
                self.showLegalDocuments(for: .privacyPolicy)
            case 3:
                self.showLegalDocuments(for: .termsAndCnditions)
            default:
                break
            }
        }
    }
    
}

//MARK: - SettingProtocol

extension SettingsTableViewController: SettingProtocol {
    
    func increaseCellSize(at indexPath: IndexPath) {
        if settingsHelper.canExpand(indexPath){
            settingsHelper.setSelectedIndex(indexPath)
            UIView.animate(withDuration: 0.55) { [self] in
                let indexPaths = self.expandedCellIndexPath != nil ? [indexPath,self.expandedCellIndexPath!] : [indexPath]
                self.tableView.reloadRows(at: indexPaths, with: .fade)
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    func getCellIndexPath(for cell: UITableViewCell) -> IndexPath {
        return tableView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
    }
    
    func getTypeOfExpandedCell(at indexPath: IndexPath) -> CellType {
        return settingsHelper.defineExpandViewForCell(at: indexPath)
    }
    
    func addChildVC(_ viewController: UIViewController){
        addChild(viewController)
    }
    
    func setExpandedCellIndexPath(_ indexPath: IndexPath?){
        self.expandedCellIndexPath = indexPath
    }
    
    func isExpandedIndexPath() -> Bool {
        return self.expandedCellIndexPath != nil
    }
}

//MARK: - MFMailComposeViewControllerDelegate & UINavigationControllerDelegate

extension SettingsTableViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
