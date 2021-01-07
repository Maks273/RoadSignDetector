//
//  SearchView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
    func filterModel(with searchText: String)
    func resetFilterModel()
}

class SearchView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var searchImageView: UIImageView! {
        didSet {
            setSearchImageView()
        }
    }
    
    //MARK: - Variables
    
    private var timer: Timer?
    weak var delegate: SearchViewDelegate?
    
    //MARK: - Initalizer/Deinitalizer
    
    deinit {
        invalidateTimer()
    }
    
    //MARK: - Initalizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        searchTextField.delegate = self
        configureStyle()
    }
    
    private func configureStyle() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.backgroundColor = .white
        setupShadow()
    }
    
    private func setupShadow() {
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.55
        containerView.layer.shadowOffset = CGSize(width: 2, height: 0)
    }
    
    private func setSearchImageView(){
        searchImageView.image = UIImage(named: "searchIcon")?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
    }
    
    private func invalidateTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    private func launchFilteringTimer(searchText: String) {
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(filteringTimerLaunched), userInfo: ["searchText": searchText], repeats: false)
    }
    
    @objc private func filteringTimerLaunched(_ timer: Timer) {
        if let userInfoDict = timer.userInfo as? [String:String] {
            if let searchText = userInfoDict["searchText"] {
                !searchText.isEmpty ? delegate?.filterModel(with: searchText) : delegate?.resetFilterModel()
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func editingChanged(_ sender: UITextField) {
        
    }
    
}

//MARK: - UITextFieldDelegate

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        containerView.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.resetFilterModel()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        launchFilteringTimer(searchText: textField.text ?? "")
        return true
    }
}
