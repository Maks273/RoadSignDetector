//
//  RoadSignDetailVCHelper.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 08.01.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import AVFoundation

class RoadSignDetailVCHelper {
    
    //MARK: - Variables
    
    private var model: RoadSign! {
        didSet {
            loadImages {
                self.didLoadImages?(self.images.count)
            }
            loadSound()
        }
    }
    private var images = [UIImage?]()
    private var sound: AVAudioPlayer?
    var didLoadImages: ((_ imagesCount: Int) -> Void)?
    var errorWithLoading: ((_ errorMessage: String) -> Void)?
    
    //MARK: - Helper
    
    func getNumberOfItems() -> Int {
        return images.count
    }
    
    func getImage(for index: Int) -> UIImage? {
        return canGetImage(at: index) ? images[index] : UIImage()
    }
    
    func setModel(_ model: RoadSign) {
        self.model = model
    }
    
    func getModel() -> RoadSign {
        return model
    }
    
    func getIndexForVisibleCell(in collectionView: UICollectionView) -> Int {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)?.item ?? 0
    }
    
    func soundHandler(for tag: Int) {
        guard isSoundValid() else {
            return
        }
        
        switch tag {
        case 0:
            sound?.play()
        case 1:
            sound?.pause()
        case 2:
            sound?.currentTime = 0
            sound?.play()
        default:
            sound?.stop()
        }
    }
    
    //MARK: - Private methods
    
    private func loadImages(completion: @escaping () -> Void) {
        guard isModelValid(), !model.images.isEmpty else {
            return
        }
    
        for imageName in self.model.images {
            FirebaseService.shared.loadImages(imageName: imageName) { (data, error) in
                if error == nil {
                    let image = UIImage(data: data!)
                    self.images.append(image)
                    completion()
                }
            }
        }
    }
    
    private func canGetImage(at index: Int) -> Bool {
        return index < model.images.count
    }
    
    private func isModelValid() -> Bool {
        return model != nil
    }
    
    private func loadSound() {
        guard isModelValid(),
              let localizeInfo = model.localizationInfo,
              let soundName = localizeInfo.sound?.name(),
              !soundName.isEmpty
        else {
            return
        }
        
        FirebaseService.shared.loadSound(soundName: soundName) { [weak self] (data, error) in
            if let error = error {
                self?.errorWithLoading?(error.localizedDescription)
            }else {
                do {
                    self?.sound = try AVAudioPlayer(data: data!)
                    if self?.canPlaySoundAutomatically() == true {
                        self?.sound?.play()
                    }
                }catch (let error) {
                    self?.errorWithLoading?(error.localizedDescription)
                }
            }
        }
    }
    
    private func isSoundValid() -> Bool {
        return sound != nil
    }
    
    private func canPlaySoundAutomatically() -> Bool {
        return Environment.shared.loadPlaySoundStatus()
    }
}
