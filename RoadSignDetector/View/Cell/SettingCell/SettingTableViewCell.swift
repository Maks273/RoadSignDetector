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

class SettingTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var containerView: SettingsView!
    
    //MARK: - Life cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Helper
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: SettingsCellModel){
        containerView.configure(with: model)
    }
    
}


