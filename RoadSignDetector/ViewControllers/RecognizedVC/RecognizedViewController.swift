//
//  RecognizedTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//
import UIKit
import Vision
import ProgressHUD

class RecognizedViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var expandedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RecognizeHeader!
    
    //MARK: - Variables
    
    var image: UIImage?
    private let recognizedHelper = RecognizedVCHelper()
    private let defaultExpandedViewHeight: CGFloat = 60
    private var isViewExpanded = false {
        didSet {
            tableView.isHidden = !isViewExpanded
        }
    }

    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderView()
        setupExpandedViewStyle()
        setupSwipeGestureRecognizers()
        setupLineViewStyle()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.dismiss()
        setupImage()
        paintRecognizedFrames()
        reloadTableView()
    }
    
    //MARK: - Helper
    
    func setRecognizedResults(_ results: [VNRecognizedObjectObservation]) {
        recognizedHelper.setRecognizedResults(results)
    }
    
    //MARK: - Private methods
    
    private func showDetailVC(with model: RoadSign) {
        let detailVC = StorybardService.main.viewController(viewControllerClass: RoadSignDetailViewController.self)
        detailVC.detailHelper.setModel(model)
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }

    private func reloadTableView() {
        recognizedHelper.modelWasAdded = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupImage() {
        guard let image = image else {
            return
        }
        imageView.image = image
    }
    
    private func setupLineViewStyle() {
        lineView.layer.cornerRadius = 5
    }
    
    //MARK: Table View
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func handleBgViewForTable(needShow: Bool) {
        let noDataLabel = UILabel()
        noDataLabel.configureNoDataLabel(for: tableView)
        tableView.backgroundView = needShow ? noDataLabel : nil
    }
    
    //MARK: ExpandedView
    
    private func setupExpandedViewStyle() {
        expandedView.layer.cornerRadius = 15
        expandedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        expandedView.backgroundColor = .white
        expandedView.layer.shadowColor = UIColor.darkGray.cgColor
        expandedView.layer.shadowRadius = 6
        expandedView.layer.shadowOpacity = 0.45
        expandedView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    //MARK:  Swipe expanded view handler
    
    private func setupSwipeGestureRecognizers() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeDetected))
        swipeUp.direction = .up
        expandedView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDetected))
        swipeDown.direction = .down
        expandedView.addGestureRecognizer(swipeDown)
    }
    
    @objc private func swipeDetected(_ swipeGesture: UISwipeGestureRecognizer) {
        switch swipeGesture.direction {
        case .up:
            isViewExpanded = true
            expandExpandedView()
        case .down:
            isViewExpanded = false
            collapseExpandedView()
        default:
            return
        }
        
    }
    
    private func expandExpandedView() {
        expandedViewHeightConstraint.constant = self.view.frame.height/2
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func collapseExpandedView() {
        expandedViewHeightConstraint.constant = defaultExpandedViewHeight
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: Paint recognized frame
    
    private func paintRecognizedFrames() {
        let frames = recognizedHelper.getBoundsBoxes(at: imageView.contentRect)
        
        for frame in frames {
            paintFrame(in: frame)
       }
        
    }
    
    private func paintFrame(in frame: CGRect) {
        let rect = UIBezierPath(rect: frame)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = rect.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        
        imageView.layer.addSublayer(shapeLayer)
    }

    //MARK: nav bar
    
    private func configureHeaderView() {
        headerView.setupTitle("Recognized")
        headerView.delegate = self
    }
    @objc private func backBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - UITableViewDelegate
extension RecognizedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = recognizedHelper.getModel(for: indexPath.row) {
            showDetailVC(with: model.roadSign)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - UITableViewDataSource
extension RecognizedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        handleBgViewForTable(needShow: recognizedHelper.isNoDataLabelVisible())
        return recognizedHelper.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recognizedCell", for: indexPath) as! RecognizedTableViewCell
        if let model = recognizedHelper.getModel(for: indexPath.row) {
            cell.configureCell(with: model)
        }

        return cell
    }
}

extension RecognizedViewController: RecognizeHeaderDelegate {
    func popToViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
