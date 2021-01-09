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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var roadSignTitleLabel: UILabel!
    @IBOutlet weak var roadSignDescriptionTextView: UITextView!
    @IBOutlet weak var expandedSoundContainerView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePageControll: UIPageControl!
    @IBOutlet weak var expandedSoundView: ExpandedSoundView!
    
    //MARK: - Variables
    let detailHelper = RoadSignDetailVCHelper()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderViewStyle()
        configureCollectionView()
        expandedSoundView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillData()
        reloadImageCollectionView()
        showSoundLoadingError()
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
    
    func fillData() {
        let model = detailHelper.getModel()
        roadSignTitleLabel.text = model.localizationInfo?.title
        roadSignDescriptionTextView.text = model.localizationInfo?.description
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
    
    private func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.isPagingEnabled = true
        setCollectionViewStyle()
    }
    
    private func setCollectionViewStyle() {
        imageCollectionView.layer.cornerRadius = 10
        imageCollectionView.layer.borderWidth = 0.5
        imageCollectionView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func reloadImageCollectionView() {
        detailHelper.didLoadImages = { [weak self] imagesCount in
            self?.imageCollectionView.reloadData()
            self?.imagePageControll.numberOfPages = imagesCount
        }
    }
    
    private func changeCurrentPage() {
        let pageNumber = detailHelper.getIndexForVisibleCell(in: imageCollectionView)
        imagePageControll.currentPage = pageNumber
    }
    
    private func showSoundLoadingError() {
        detailHelper.errorWithLoading = { [weak self] errorMessage in
            self?.showAlert(with: errorMessage)
        }
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UICollectionViewDataSource

extension RoadSignDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailHelper.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roadSignImageCell", for: indexPath) as! RoadSignImageCollectionViewCell
        cell.setupImage(detailHelper.getImage(for: indexPath.row))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeCurrentPage()
    }
    
}

//MARK: - UICollectionViewDelegate

extension RoadSignDetailViewController: UICollectionViewDelegate {
    
}

//MARK: - ExpandedSoundDelegate

extension RoadSignDetailViewController: ExpandedSoundDelegate {
    func callSpecificHandler(for tag: Int) {
        detailHelper.soundHandler(for: tag)
    }
}
