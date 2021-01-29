//
//  LegalDocsViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 29.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class LegalDocsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerView: RecognizeHeader!
    
    //MARK: - Variables
    
    var headerTitle: String?
    var documentContext: String?
    var errorMessage: String?
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderView()
        setDocumentConxtext()
    }
    
    
    //MARK: - Helper

    //MARK: Private methods
    
    private func configureHeaderView() {
        headerView.delegate = self
        headerView.setupTitle(headerTitle)
    }
    
    private func setDocumentConxtext() {
        textView.text = documentContext
    }
}

extension LegalDocsViewController: RecognizeHeaderDelegate {
    func popToViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
