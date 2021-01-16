//
//  RecognizedTableViewCell.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 15.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class RecognizedTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    
    @IBOutlet weak var recognizedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    //MARK: - overrided methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper
    
    func configureCell(with model: RecognizedItem) {
        launchImageLoading(with: model.roadSign.images)
        nameLabel.text = model.roadSign.localizationInfo?.title
        percentLabel.text = "\(model.precent)%"
    }
    
    
    //MARK: - Private methods
    
    private func launchImageLoading(with imageNames: [String]) {
        if let imageName = imageNames.first {
            loadImage(with: imageName)
        }
    }
    
    private func loadImage(with name: String) {
        FirebaseService.shared.loadImages(imageName: name) { (data, error) in
            if error == nil {
                if let data = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.recognizedImageView?.image = image
                    }
                }
            }
        }
    }

}
