//
//  LanguageItemTableViewCell.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 01.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class LanguageItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var separateLineView: UIView!
    
    var languageCode: String = ""{
        didSet{
            let currentLanguage = UserDefaults.standard.string(forKey: "AppleLanguage")
            selectButton.backgroundColor = currentLanguage == languageCode ? .purple : .gray
        }
    }
    
    weak var delegate: LanguageProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectBtnWasPressed(_ sender: Any) {
        UserDefaults.standard.set(languageCode, forKey: "AppleLanguage")
        UserDefaults.standard.synchronize()
        Bundle.swizzleLocalization()
        delegate.reloadTableView()
    }
    
    func cofigureCell(text: String, separateLineStatus: Bool){
        selectButton.layer.cornerRadius = selectButton.bounds.width/2
        separateLineView.isHidden = separateLineStatus
        titleLabel.text = text
    }
}
