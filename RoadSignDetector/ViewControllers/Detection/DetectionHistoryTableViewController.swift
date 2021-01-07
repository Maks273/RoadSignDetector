//
//  DetectionHistoryTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class DetectionHistoryTableViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var historyHeaderView: HistoryHeaderView!
    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.tableFooterView = UIView()
        }
    }
    
    //MARK: - Variables
    private let cellIdentifire = "historyCell"
    private let detectionHistoryHelper = DetectionHistoryVCHelper()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detectionHistoryHelper.observeCurrentUser()
        reloadTableView()
    }
    
    //MARK: - Private methods
    
    private func reloadTableView() {
        detectionHistoryHelper.modelWasAdded = { [weak self] in
            self?.historyTableView.reloadData()
        }
    }
    
    private func configureTableView() {
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifire)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyHeaderView.delegate = self
    }
    
    //MARK: Swipe images
    
    private func prepareSwipeImage(name: String, color: UIColor) -> UIImage? {
        let image = UIImage(named: name)?.withTintColor(color)
        image?.withAlignmentRectInsets(UIEdgeInsets(top: -7, left: -7, bottom: -7, right: -7))
        return image
    }
    
    private func openDetailVC(for model: RoadSign) {
        let detailVC = StorybardService.main.viewController(viewControllerClass: RoadSignDetailViewController.self)
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate

extension DetectionHistoryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire) as! HistoryTableViewCell
        if let model = detectionHistoryHelper.getModel(for: indexPath.row) {
            cell.configure(with: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = detectionHistoryHelper.getModel(for: indexPath.row) {
            openDetailVC(for: model)
        }
    }
    
    //MARK: Swipe
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, status) in
            // TODO: action for set and unset cell favorite
        }
        let imageName = detectionHistoryHelper.getFavoriteImageName(for: indexPath.row)
        favoriteAction.image = prepareSwipeImage(name: imageName, color: .systemYellow)
        favoriteAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, status) in
            self?.detectionHistoryHelper.removeHistoryItem(for: indexPath.row)
        }
        deleteAction.image = prepareSwipeImage(name: "garbageIcon", color: .systemRed)
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}

//MARK: - UITableViewDataSource

extension DetectionHistoryTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detectionHistoryHelper.getNumberOfRows()
    }
    
}
//MARK: - HistoryHeaderDelegate

extension DetectionHistoryTableViewController: HistoryHeaderDelegate {    
    func changeCurrentSelectedHistoryType(for tag: Int) {
        detectionHistoryHelper.setCurrentHistoryType(for: tag)
    }
}
