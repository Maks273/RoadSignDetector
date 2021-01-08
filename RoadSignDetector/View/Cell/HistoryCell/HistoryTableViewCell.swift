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
    
    //MARK: - Overrided funcs
    
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
        signTitleLabel.text = model.localizationInfo?.title
        signDescriptionLabel.text = model.localizationInfo?.description
        loadImage(with: model.images[0])
        animateAppearing()
    }
    
    //MARK: - Private methods
    
    private func configureStyle(){
        self.containerView.layer.cornerRadius = 15
        self.containerView.backgroundColor = .white
        configureImageViewStyle()
        setupShadow()
    }
    
    private func configureImageViewStyle() {
        signImageView.layer.cornerRadius = 10
        signImageView.layer.borderWidth = 0.5
        signImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupShadow(){
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private func loadImage(with imageName: String) {
        FirebaseService.shared.loadImages(imageName: imageName) { [weak self] (data, error) in
            if let error = error {
                NSLog("ERROR with loading image = \(imageName) -> ", error.localizedDescription)
            }else {
                self?.setupImage(from: data!)
            }
        }
    }
    
    private func setupImage(from data: Data) {
        UIView.animate(withDuration: 1) {
            self.signImageView?.image = UIImage(data: data)
            self.signImageView.alpha = 1
        }
    }
    
    private func animateAppearing() {
        UIView.animate(withDuration: 1) {
            self.signTitleLabel.alpha = 1
            self.signDescriptionLabel.alpha = 1
        }
    }
    
    
}
