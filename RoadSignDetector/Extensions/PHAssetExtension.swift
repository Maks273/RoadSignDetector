//
//  PHAssetExtension.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 26.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

extension PHAsset {
    func getAssetThumbnail() -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
        })
        return thumbnail
    }
}
