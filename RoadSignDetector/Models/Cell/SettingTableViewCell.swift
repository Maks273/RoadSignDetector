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
    
    //MARK: - Life cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Helper
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text: String, for position: CellPosition, showMoreVisible: Bool){
        
        isExpanded = contentView.bounds.height > 80 ? true : false
        indexPath = delegate?.getCellIndexPath(for: self)
        
        titleLabel.text = text
        showMoreBtn.isHidden = showMoreVisible
        separatorLine.isHidden = position == .last
        verticalLine.backgroundColor = .purple
        setupContainerViewShadow()
        
        if position != .intermediate {
            setupCornerStyle(for: position)
        }
        
        configureExtraView()
    }
    
    //MARK: - IBActions
    
    @IBAction func showBtnPressed(_ sender: Any) {
        isExpanded!.toggle()
        if let indexPath = delegate?.getCellIndexPath(for: self){
            delegate?.increaseCellSize(at: indexPath)
        }
    }
    
    
    //MARK: - Private methods
    
    private func setupCornerStyle(for position: CellPosition){
        let shadowHeight = position == .first ? -2 : 2
        
        verticalLine.layer.cornerRadius =  7
        containerView.layer.cornerRadius =  7
        
        verticalLine.layer.maskedCorners = position == .first ? [.layerMinXMinYCorner] : [.layerMinXMaxYCorner]
        containerView.layer.maskedCorners = position == .first ? [.layerMaxXMinYCorner] : [.layerMaxXMaxYCorner]
        
        containerView.layer.shadowOffset = CGSize(width: 2, height: shadowHeight)
        
        if position == .first {
            containerViewTopConstraint.constant = 3
        }else{
            if containerViewBottomConstraint != nil{
                containerViewBottomConstraint.constant = 3
            }
        }
        
    }
    
    private func setupContainerViewShadow(){
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowRadius = 7
        containerView.layer.shadowOpacity = 0.7
    }
    
    private func toggleButtonImage(_ show: Bool){
        let image = UIImage(named: show ? "upArrow" : "downArrow")
        showMoreBtn.setImage(image, for: .normal)
    }
    
    private func setupExtraView(for type: CellType){
        switch type {
        case .language:
            prepareExtaView(view: AudioView())
        case .audio:
            prepareExtaView(view: AudioView())
        }
    }
    
    private func prepareExtaView(view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.isHidden = true
        contentView.addSubview(view)
        
        if containerViewBottomConstraint != nil{
            containerViewBottomConstraint.isActive = false
        }
        
        view.addConstraints([
            view.heightAnchor.constraint(equalToConstant: 81),
        ])
        
        contentView.addConstraints([
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0)
        ])
        
        UIView.animate(withDuration: 0.55) {
            self.containerView.layoutIfNeeded()
        }
    }
    
    private func configureExtraView(){
        if !showMoreBtn.isHidden && indexPath != nil {
            cellType = delegate?.getTypeOfExpandedCell(at: indexPath!)
        }
        if isExpanded! {
            self.setupExtraView(for: cellType!)
        }
        toggleButtonImage(isExpanded!)
    }
    
    private func collapsExtraView(for type: CellType) {
        switch type {
        case .language:
            AudioView().removeFromSuperview()
        case .audio:
            AudioView().removeFromSuperview()
        }
    }
    
}


