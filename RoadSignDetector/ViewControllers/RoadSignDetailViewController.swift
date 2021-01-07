//
//  RoadSignDetailViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 15.12.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class RoadSignDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var roadSignImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var roadSignTitleLabel: UILabel!
    @IBOutlet weak var roadSignDescriptionTextView: UITextView!
    @IBOutlet weak var expandedSoundContainerView: UIView!
    
    //MARK: - Variables
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderViewStyle()
    }
    
    //MARK: - IBActions
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func expandSoundControllBtnWasPressed(_ sender: Any) {
        handleExpandedViewDisplaying(needShow: true)
    }
    
    @IBAction func collapsedBtnWasPressed(_ sender: Any) {
        handleExpandedViewDisplaying(needShow: false)
    }
    
    
    //MARK: - Hepler
    
    func fillData(with model: RoadSign) {
//        roadSignTitleLabel.text = model.title
//        roadSignDescriptionTextView.text = model.desription
        //loading image will be from some service
    }
    
    //MARK: - Private methods
    
    private func configureHeaderViewStyle() {
        headerView.layer.cornerRadius = 50
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    private func handleExpandedViewDisplaying(needShow: Bool) {
        expandedSoundContainerView.alpha = needShow ? 0 : 1
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 10, initialSpringVelocity: 15, options: .transitionFlipFromRight) {
            self.expandedSoundContainerView.isHidden = !needShow
            self.expandedSoundContainerView.alpha = needShow ? 1 : 0
            
        } completion: { (finished) in }
    }
}
