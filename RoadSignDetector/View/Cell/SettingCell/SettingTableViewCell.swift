//
//  SettingTableViewCell.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

enum CellPosition {
    case first
    case intermediate
    case last
}

enum CellType {
    case language
    case audio
    
    func positionIndex() -> IndexPath {
        switch self {
        case .language:
            return IndexPath(row: 0, section: 0)
        case .audio:
            return IndexPath(row: 1, section: 0)
        }
    }
}

protocol SettingCellProtocol: class {
    func expandExtraView(for type: CellType)
    func collapsExtraView(for type: CellType)
}

class SettingTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verticalLine: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreBtn: UIButton!
    
    //MARK: - Variables
    
    var isExpanded: Bool?
    weak var delegate: SettingProtocol?
    private var indexPath: IndexPath?
    private var cellType: CellType?
    private var cellPosition: CellPosition?
    private let extraViewTag = 8
    
    //MARK: - Life cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Helper
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text: String, for position: CellPosition, showMoreVisible: Bool, at indexPath: IndexPath){
        
        isExpanded = contentView.bounds.height > 80 ? true : false
        self.indexPath = indexPath
        self.cellPosition = position
        
        titleLabel.text = text
        showMoreBtn.isHidden = showMoreVisible
        separatorLine.isHidden = position == .last
        verticalLine.backgroundColor = .purple
        setupContentViewShadow()
        
        configureExtraView(!showMoreVisible)
        
        if position != .intermediate {
            setupCornerStyle(for: position)
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func showBtnPressed(_ sender: Any) {
        isExpanded!.toggle()
        if let indexPath = delegate?.getCellIndexPath(for: self){
            delegate?.increaseCellSize(at: indexPath)
            delegate?.setExpandedCellIndexPath(isExpanded! ? indexPath : nil)
        }
    }
    
    
    //MARK: - Private methods
    
    private func setupCornerStyle(for position: CellPosition){
        let shadowHeight = position == .first ? -2 : 2
        
        verticalLine.layer.cornerRadius =  7
        containerView.layer.cornerRadius =  7
        
        verticalLine.layer.maskedCorners = position == .first ? [.layerMinXMinYCorner] : [.layerMinXMaxYCorner]
        containerView.layer.maskedCorners = position == .first || isExpanded! ? [.layerMaxXMinYCorner] : [.layerMaxXMaxYCorner]
        
        containerView.layer.shadowOffset = CGSize(width: 4, height: shadowHeight)
        
        if position == .first {
            containerViewTopConstraint.constant = 3
        }else{
            if containerViewBottomConstraint != nil{
                containerViewBottomConstraint.constant = 3
                self.contentView.layoutIfNeeded()
            }
        }
        
    }
    
    private func setupContentViewShadow(){
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowRadius = 7
        contentView.layer.shadowOpacity = 0.7
    }
    
    private func toggleButtonImage(_ show: Bool){
        let image = UIImage(named: show ? "upArrow" : "downArrow")
        image?.withTintColor(.black)
        showMoreBtn.setImage(image, for: .normal)
    }
    
    //MARK: - Extra View configuration
    
    private func setupExtraView(for type: CellType){
        let extraView: UIView!
        switch type {
        case .language:
            let languageVC = LanguageTableViewController()
            delegate?.addChildVC(languageVC)
            extraView = languageVC.view
        case .audio:
            extraView = AudioView()
        }
        prepareExtaView(view: extraView)
    }
    
    private func prepareExtaView(view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = extraViewTag
        
        view.layer.cornerRadius = 7
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 4, height: 6)
        
        separatorLine.isHidden = true
        contentView.addSubview(view)
        
        if containerViewBottomConstraint != nil{
            containerViewBottomConstraint.isActive = false
        }
        
        view.addConstraints([
            view.heightAnchor.constraint(equalToConstant: 120),
        ])
        
        contentView.addConstraints([
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0)
        ])
    }
    
    private func configureExtraView(_ needConfigure: Bool){
        if needConfigure && indexPath != nil {
            cellType = delegate?.getTypeOfExpandedCell(at: indexPath!)
            removeExtraView(with: extraViewTag)
            if isExpanded! {
                setupExtraView(for: cellType!)
            }
            toggleButtonImage(isExpanded!)
        }
    }
    
    private func removeExtraView(with tag: Int){
        for subview in contentView.subviews{
            if subview.tag == tag{
                subview.removeFromSuperview()
                containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
                containerViewBottomConstraint.isActive = true
            }
        }
    }
    
}


