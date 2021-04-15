//
//  RecognizeHeader.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 29.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol RecognizeHeaderDelegate: class {
    func popToViewController()
}

class RecognizeHeader: UIView {

    //MARK: - IBOutlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Variables
    
    weak var delegate: RecognizeHeaderDelegate?
    
    //MARK: - Initalziers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - IBActions
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        delegate?.popToViewController()
    }
    
    //MARK: - Helper
    
    func setupTitle(_ title: String?) {
        titleLabel.text = title?.localized()
        titleLabel.textColor = .black
    }
    
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RecognizeHeader", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        setupStyle()
    }
    
    private func setupStyle() {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemPurple.cgColor
        containerView.backgroundColor = .white
    }

}
