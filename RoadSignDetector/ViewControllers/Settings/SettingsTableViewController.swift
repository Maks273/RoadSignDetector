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
}

class SettingsTableViewController: UITableViewController {
    
    //MARK: - Variables
    
    let settingsViewModel = SettingsViewModel()
    let cellIdentifire = "settingCell"
    
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
        cell.configure(text: title, for: cellPosition, showMoreVisible: showMoreStatus)
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
            UIView.animate(withDuration: 0.55) {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
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
    
}
