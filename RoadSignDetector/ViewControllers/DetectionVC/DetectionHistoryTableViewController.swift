//
//  DetectionHistoryTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit
import ProgressHUD

class DetectionHistoryTableViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var historyHeaderView: HistoryHeaderView!
    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var searchView: SearchView!
    
    
    //MARK: - Variables
    private let cellIdentifire = "historyCell"
    private var detectionHistoryHelper: DetectionHistoryVCHelper?
    let refreshControll = UIRefreshControl()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addNetworkObserver(in: self)
        if detectionHistoryHelper == nil {
            detectionHistoryHelper = DetectionHistoryVCHelper()
        }
        detectionHistoryHelper?.observeCurrentUser()
        reloadTableView()
        setTargetForRefreshControll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeNetworkObserver(in: self)
    }
    
    
    //MARK: - IBActions
    
    
    //MARK: - Private methods
    
    private func reloadTableView() {
        detectionHistoryHelper?.modelWasAdded = { [weak self] in
            self?.detectionHistoryHelper?.showLoadingSpinner()
            self?.historyTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                ProgressHUD.dismiss()
            }
        }
    }
    
    private func configureTableView() {
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifire)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyHeaderView.delegate = self
        searchView.delegate = self
        historyTableView.refreshControl = refreshControll
    }
    
    private func setTargetForRefreshControll()  {
        refreshControll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData(_ refreshControll: UIRefreshControl) {
        detectionHistoryHelper?.loadHistoryData()
        refreshControll.endRefreshing()
    }
    
    private func handleBgViewForTable(needShow: Bool) {
        let noDataLabel = configureNoDataLabel()
        historyTableView.backgroundView = needShow ? noDataLabel : nil
    }
    
    private func configureNoDataLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: historyTableView.bounds.width, height: historyTableView.bounds.height))
        label.translatesAutoresizingMaskIntoConstraints = true
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "There are no data at the moment."
        label.font = UIFont(name: "AvenirNext-Regular", size: 17)
        return label
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
        detailVC.detailHelper.setModel(model)
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
        if let model = detectionHistoryHelper?.getModel(for: indexPath.row) {
            cell.configure(with: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = detectionHistoryHelper?.getModel(for: indexPath.row) {
            openDetailVC(for: model)
        }
    }
    
    //MARK: Swipe
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, status) in
            self?.detectionHistoryHelper?.handleFavoriteStatus(for: indexPath.row)
        }
        if let imageName = detectionHistoryHelper?.getFavoriteImageName(for: indexPath.row) {
            favoriteAction.image = prepareSwipeImage(name: imageName, color: .systemYellow)
        }
        favoriteAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, status) in
            self?.detectionHistoryHelper?.removeHistoryItem(for: indexPath.row)
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
        handleBgViewForTable(needShow: detectionHistoryHelper?.isNoDataLabelVisible() ?? false)
        return detectionHistoryHelper?.getNumberOfRows() ?? 0
    }
    
}
//MARK: - HistoryHeaderDelegate

extension DetectionHistoryTableViewController: HistoryHeaderDelegate {    
    func changeCurrentSelectedHistoryType(for tag: Int) {
        detectionHistoryHelper?.setCurrentHistoryType(for: tag)
    }
}

//MARK: - SearchViewDelegate

extension DetectionHistoryTableViewController: SearchViewDelegate {
    func filterModel(with searchText: String) {
        ProgressHUD.show()
        detectionHistoryHelper?.filterHistoryModel(with: searchText)
    }
    
    func resetFilterModel() {
        detectionHistoryHelper?.resetFilterModel()
    }
}
