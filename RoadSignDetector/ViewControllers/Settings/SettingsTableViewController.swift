//
//  SettingsTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit


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
    
    let settingsViewModel = SettingsViewModel()
    let cellIdentifire = "settingCell"
    private var expandedCellIndexPath: IndexPath?
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsViewModel.getNumberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.getNumberOfRow(at: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingsViewModel.getRowHeight(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! SettingTableViewCell
        cell.delegate = self
        let title = settingsViewModel.getCellTitle(at: indexPath)
        let cellPosition = settingsViewModel.defineCellPosition(at: indexPath)
        let showMoreStatus = settingsViewModel.showMoreStatus(at: indexPath)
        cell.configure(text: title, for: cellPosition, showMoreVisible: showMoreStatus, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = settingsViewModel.headerTitles[section]
        return configureHeaderView(with: headerTitle)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !settingsViewModel.canExpand(indexPath){
            print("second section")
        }
    }
    
}

extension SettingsTableViewController: SettingProtocol {
    
    func increaseCellSize(at indexPath: IndexPath) {
        if settingsViewModel.canExpand(indexPath){
            settingsViewModel.setSelectedIndex(indexPath)
            UIView.animate(withDuration: 0.55) { [self] in
                let indexPaths = self.expandedCellIndexPath != nil ? [indexPath,self.expandedCellIndexPath!] : [indexPath]
                print("INDEX PATTTTT = \(indexPaths)")
                self.tableView.reloadRows(at: indexPaths, with: .fade)
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    func getCellIndexPath(for cell: UITableViewCell) -> IndexPath {
        return tableView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
    }
    
    func getTypeOfExpandedCell(at indexPath: IndexPath) -> CellType {
        return settingsViewModel.defineExpandViewForCell(at: indexPath)
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
