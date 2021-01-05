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
    
    //MARK: - Variables
    
    let headerTitles = ["General".localized(),"Extra".localized()]
    var menuItemTitles: [[String]] {
        return [generalMenuItem,extraMenuItem]
    }
    let cellIdentifire = "settingCell"
    
    //MARK: Private
    
    private var selectedIndex: IndexPath?
    private var expandedCellIndexPath: IndexPath?
    private let generalMenuItem = ["Languages".localized(),"Audio".localized()]
    private let extraMenuItem  = ["Contact us".localized(),"Privacy policy".localized(),"Rate the app".localized()]
    private let developerEmail = "paydich28@gmail.com"
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifire)
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
    
    private func getNumberOfSection() -> Int {
        return headerTitles.count
    }
    
    private func getNumberOfRow(at section: Int) -> Int {
        return menuItemTitles[section].count
    }
    
    private func getRowHeight(at indexPath: IndexPath) -> CGFloat {
        if selectedIndex != nil && indexPath == selectedIndex {
            return 188
        }
        return 65
    }
    
    private func defineCellPosition(at indexPath: IndexPath) -> CellPosition {
        if indexPath.row == 0 {
            return .first
        }else if indexPath.row == menuItemTitles[indexPath.section].count - 1 {
            return .last
        }else {
            return .intermediate
        }
    }
    
    private func canExpand(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    private func setSelectedIndex(_ selectedIndex: IndexPath) {
        self.selectedIndex = selectedIndex == self.selectedIndex ? nil : selectedIndex
    }
    
    private func getSelectedIndex() -> IndexPath? {
        return selectedIndex
    }
    
    private func defineExpandViewForCell(at indexPath: IndexPath) -> CellType {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return .language
        case IndexPath(row: 1, section: 0):
            return .audio
        default:
            return .language
        }
    }
    
    private func getCellTitle(at indexPath: IndexPath) -> String {
        return indexPath.section > menuItemTitles.count-1 || indexPath.row > menuItemTitles[indexPath.section].count-1 ? "" : menuItemTitles[indexPath.section][indexPath.row]
    }
    
    private func showMoreStatus(at indexPath: IndexPath) -> Bool {
        return indexPath.section == menuItemTitles.count - 1
    }
    
    private func openEmailApp() {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([developerEmail])
            present(mailVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return getNumberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRow(at: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getRowHeight(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! SettingTableViewCell
        cell.delegate = self
        let title = getCellTitle(at: indexPath)
        let cellPosition = defineCellPosition(at: indexPath)
        let showMore = showMoreStatus(at: indexPath)
        cell.configure(text: title, for: cellPosition, showMoreVisible: showMore, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = headerTitles[section]
        return configureHeaderView(with: headerTitle)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !canExpand(indexPath){
            tableView.deselectRow(at: indexPath, animated: true)
            switch indexPath.row {
            case 0:
                self.openEmailApp()
            default:
                break
            }
        }
    }
    
}

//MARK: - SettingProtocol

extension SettingsTableViewController: SettingProtocol {
    
    func increaseCellSize(at indexPath: IndexPath) {
        if canExpand(indexPath){
            setSelectedIndex(indexPath)
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
        return defineExpandViewForCell(at: indexPath)
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
