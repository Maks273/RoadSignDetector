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
    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.tableFooterView = UIView()
        }
    }
    
    //MARK: - Variables
    private let cellIdentifire = "historyCell"
    var model = [RoadSign]()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.append(RoadSign(title: "ROAD", desription: "SIGNFSFSAFSAFSMFSFMSKFASFKSANFKAFNSAKFANSFKSAFNSAKFNASKF", imageStringURL: "ddds"))
        model.append(RoadSign(title: "ROAD", desription: "SIGNFSFSAFSAFSMFSFMSKFASFKSANFKAFNSAKFANSFKSAFNSAKFNASKF", imageStringURL: "ddds"))
        model.append(RoadSign(title: "ROAD", desription: "SIGNFSFSAFSAFSMFSFMSKFASFKSANFKAFNSAKFANSFKSAFNSAKFNASKF", imageStringURL: "ddds"))
        model.append(RoadSign(title: "ROAD", desription: "SIGNFSFSAFSAFSMFSFMSKFASFKSANFKAFNSAKFANSFKSAFNSAKFNASKF", imageStringURL: "ddds"))
        model.append(RoadSign(title: "ROAD", desription: "SIGNFSFSAFSAFSMFSFMSKFASFKSANFKAFNSAKFANSFKSAFNSAKFNASKF", imageStringURL: "ddds"))
        model.append(RoadSign(title: "ROAD", desription: "SIGNFSFSAFSAFSMFSFMSKFASFKSANFKAFNSAKFANSFKSAFNSAKFNASKF", imageStringURL: "ddds"))
        
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifire)
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    //MARK: - Private methods
    
    private func getCurrentModel(for index: Int) -> RoadSign? {
        canGetModel(for: index) ? model[index] : nil
    }
    
    private func canGetModel(for index: Int) -> Bool {
        return index < model.count - 1
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
    
}

//MARK: - UITableViewDataSource

extension DetectionHistoryTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire) as! HistoryTableViewCell
        cell.configure(with: model[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openDetailVC(for: model[indexPath.row])
    }
    
    //MARK: Swipe
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { (action, view, status) in
            // TODO: action for set and unset cell favorite
        }
        favoriteAction.image = prepareSwipeImage(name: "filledStar", color: .systemYellow)
        favoriteAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, status) in
            // TODO: action for removing cell from history and from server db
        }
        deleteAction.image = prepareSwipeImage(name: "garbageIcon", color: .systemRed)
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}
