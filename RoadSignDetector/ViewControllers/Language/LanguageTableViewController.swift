//
//  LanguageTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 01.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

protocol LanguageProtocol: class {
    func languageCode() -> String
    func reloadTableView()
}

class LanguageTableViewController: UITableViewController {

    //MARK: - Variables
    var languageViewModel = LanguageViewModel()
    let cellIdentifire = "languageCell"
    
    //MARK: - View cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "LanguageItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifire)
        tableView.separatorStyle = .none
        self.view.tag = 8
    }
    
    //MARK: - Private methods

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageViewModel.getCellNumber()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! LanguageItemTableViewCell
        let title = languageViewModel.getTitle(at: indexPath)
        let isLastCell = languageViewModel.isLastCell(at: indexPath)
        cell.delegate = self
        cell.languageCode = languageViewModel.getLanguageCode(for: indexPath)
        cell.cofigureCell(text: title, separateLineStatus: isLastCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("WAS SELECTED")
    }


}

extension LanguageTableViewController: LanguageProtocol {
    func languageCode() -> String {
        return ""
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
