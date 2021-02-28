//
//  AudiSettingsTableViewCell.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class AudioSettingsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var audioView: AudioView!
    
    //MARK: - override func

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper
    
    func configure(with model: SettingsCellModel) {
        audioView.settingsView.configure(with: model)
    }

}
