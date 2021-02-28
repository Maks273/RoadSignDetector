//
//  SettingsView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 27.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var verticalLine: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoView: UIView!
    
    //MARK: - Variables
    
    private var model: SettingsCellModel!
    private var shadowLayer: CAShapeLayer!
    private let cornerRadius: CGFloat = 7
    
    //MARK: - Initalizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Helper
    
    func configure(with model: SettingsCellModel) {
        self.model = model
        titleLabel.text = model.title
        verticalLine.backgroundColor = .purple
        arrowImageView.isHidden = !model.showMoreVisible
        separatorLine.isHidden = model.position == .last || model.isExpanded
        toggleArrowImage(model.isExpanded)
        
        if model.position == .last && !model.isExpanded {
            setupContentViewShadow()
        }
        
        if model.position != .intermediate {
            setupCornerStyle(for: model.position)
        }
    }
    
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SettingsView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupContentViewShadow() {
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 10,
                                                            y: bounds.maxY - 5,
                                                            width: bounds.width - 40,
                                                            height: 3)).cgPath
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 4.0
    }
    
    private func setupCornerStyle(for position: CellPosition){
        verticalLine.defalutVerticalLine(with: position == .first || model.isExpanded  ? [.layerMinXMinYCorner] : [.layerMinXMaxYCorner], cornerRadius: model.isExpanded ? 0 : 5)

        shadowView.layer.cornerRadius = model.isExpanded ? 0 : cornerRadius
        containerView.layer.cornerRadius = model.isExpanded ? 0 : cornerRadius
        infoView.layer.cornerRadius = model.isExpanded ? 0 : cornerRadius
        
        shadowView.layer.maskedCorners = position == .first || model.isExpanded ? [.layerMaxXMinYCorner] : [.layerMaxXMaxYCorner]
        
    
        if position == .first {
            containerViewTopConstraint.constant = 0
        }else{
            if containerViewBottomConstraint != nil{
                containerViewBottomConstraint.constant = model.isExpanded ? 0 : cornerRadius
                self.layoutIfNeeded()
            }
        }
        
        
    }
    
    private func toggleArrowImage(_ show: Bool){
        let image = UIImage(named: show ? "upArrow" : "downArrow")
        image?.withTintColor(.black)
        arrowImageView.image = image
    }
    
}
