//
//  HistoryHeaderView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

protocol HistoryHeaderDelegate: class {
    func changeCurrentSelectedHistoryType(for tag: Int)
}

class HistoryHeaderView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var underlineViews: [UIView]!
    
    //MARK: - Variables
    
    weak var delegate: HistoryHeaderDelegate?
    
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
    
    private func commonInit(){
        Bundle.main.loadNibNamed("HistoryHeaderView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        configureStyle()
    }
    
    private func configureStyle(){
        self.containerView.layer.cornerRadius = 55
        self.containerView.backgroundColor = .white
        self.containerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        setupShadow()
    }
    
    private func setupShadow(){
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.55
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private func switchUnderlineView(for senderTag: Int){
        for view in underlineViews {
            view.alpha = 0
            UIView.animate(withDuration: 0.75) {
                view.isHidden = view.tag != senderTag
                view.alpha = 1
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func historyTypeChangeBtnWasPressed(_ sender: UIButton) {
        switchUnderlineView(for: sender.tag)
        delegate?.changeCurrentSelectedHistoryType(for: sender.tag)
    }

}
