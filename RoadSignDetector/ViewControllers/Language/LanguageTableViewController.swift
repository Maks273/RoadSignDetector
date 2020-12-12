//
//  LanguageTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 01.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

protocol LanguageProtocol: class {
    func reloadTableView()
}

class LanguageTableViewController: UITableViewController {

    //MARK: - Variables
    let cellIdentifire = "languageCell"
    private let languages = ["English 🇺🇸".localized(),"Ukrainian 🇺🇦".localized(),"Russian 🇷🇺".localized()]
    private let languageCode = ["en","uk","ru"]
    
    //MARK: - View cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "LanguageItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifire)
        tableView.separatorStyle = .none
        self.view.tag = 8
    }
    
    //MARK: - Private methods
    
    private func getCellNumber() -> Int {
        return languages.count
    }
    
    private func checkIsLastCell(at indexPath: IndexPath) -> Bool {
        return indexPath.row == languages.count-1
    }
    
    private func getTitle(at indexPath: IndexPath) -> String {
        return indexPath.row > languages.count-1 ? "" : languages[indexPath.row]
    }
    
    private func getLanguageCode(for indexPath: IndexPath) -> String {
        return indexPath.row > languageCode.count-1 ? "" : languageCode[indexPath.row]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCellNumber()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! LanguageItemTableViewCell
        let title = getTitle(at: indexPath)
        let isLastCell = checkIsLastCell(at: indexPath)
        cell.delegate = self
        cell.languageCode = getLanguageCode(for: indexPath)
        cell.cofigureCell(text: title, separateLineStatus: isLastCell)
        return cell
    }
    
}

extension LanguageTableViewController: LanguageProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}
