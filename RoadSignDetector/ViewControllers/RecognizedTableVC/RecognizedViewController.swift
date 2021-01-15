//
//  RecognizedTableViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Vision

class RecognizedViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var expandedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
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
        setupExpandedViewStyle()
        setupSwipeGestureRecognizers()
        setupLineViewStyle()
        configureNavView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupImage()
        paintRecognizedFrames()
    }
    
    //MARK: - Helper
    
    func setRecognizedResults(_ results: [VNRecognizedObjectObservation]) {
        recognizedHelper.setRecognizedResults(results)
    }
    
    //MARK: - Private methods

    
    private func setupImage() {
        guard let image = image else {
            return
        }
        imageView.image = image
    }
    
    private func setupLineViewStyle() {
        lineView.layer.cornerRadius = 5
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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
        let frames = recognizedHelper.getBoundsBoxes()
        
        for frame in frames {
            let convertedRect = CGRect(x: Double(frame.maxX * 100), y: Double(frame.maxY) * 100, width: Double(frame.width * 100), height: Double(frame.height) * 100)
            paintFrame(in: convertedRect)
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
    
    private func configureNavView() {
        navigationTitleLabel.text = "Recognized"
        setupNavBarStyle()
        setupBtnTarget()
    }
    
    private func setupNavBarStyle() {
        navigationView.layer.borderWidth = 1
        navigationView.layer.borderColor = UIColor.systemPurple.cgColor
        navigationView.backgroundColor = .white
    }
    
    private func setupBtnTarget() {
        backBtn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
    }
    
    @objc private func backBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - UITableViewDelegate

extension RecognizedViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource

extension RecognizedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

