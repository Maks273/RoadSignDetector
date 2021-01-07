//
//  HistoryTableViewCell.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 13.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signImageView: UIImageView!
    @IBOutlet weak var signTitleLabel: UILabel!
    @IBOutlet weak var signDescriptionLabel: UILabel!

    //MARK: - Override funcs
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
    }
    
    //MARK: - Helper
    
    func configure(with model: RoadSign) {
        configureStyle()
        signTitleLabel.text = model.ukrainian?.title
        signDescriptionLabel.text = model.ukrainian?.description
    }

    
    //MARK: - Private methods
    
    private func configureStyle(){
        self.containerView.layer.cornerRadius = 15
        self.containerView.backgroundColor = .white
        signImageView.layer.cornerRadius = 10
        signImageView.backgroundColor = .gray
        setupShadow()
    }
    
    private func setupShadow(){
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}
