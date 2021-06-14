//
//  ScaningViewController.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 28.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import ProgressHUD
import Reachability
import Vision
import AssetsPickerViewController

class ScanningViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var openGalleryBtn: UIButton!
    @IBOutlet weak var openCameraBtn: UIButton!
    
    //MARK: - Variables
    
    private var pickedImages: [UIImage] = [] {
        didSet {
            showConfirmAlert()
        }
    }
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocalization() 
        setupStyleForOpenButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addNetworkObserver(in: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeNetworkObserver(in: self)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func openCameraBtnPressed(_ sender: UIButton) {
        #if !targetEnvironment(simulator)
        handleCameraRequest()
        #endif
    }
    
    @IBAction func openGalleryBtnPressed(_ sender: UIButton) {
        handlePhotoLibraryRequestStatus()
    }
    
    //MARK: - Helper
    
    
    //MARK: - Private methods
    
    private func updateLocalization() {
        openCameraBtn.localizedTitle()
        openGalleryBtn.localizedTitle()
    }
    
    private func setupStyleForOpenButtons() {
        setupStyleForBtn(openCameraBtn)
        setupStyleForBtn(openGalleryBtn)
    }
    
    private func setupStyleForBtn(_ button: UIButton) {
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    //MARK: Picker helper
    
    private func showImagePicker(by type: UIImagePickerController.SourceType) {
        let  imagePicker = AssetsPickerViewController()
        imagePicker.pickerDelegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        let  imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: PhotoLibraryRequest
    
    private func handlePhotoLibraryRequestStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            showImagePicker(by: .photoLibrary)
        case .denied, .restricted:
            ProgressHUD.showError("To open photos you need to get access in settings.".localized())
        default:
            makePhotoLibraryRequest()
        }
    }
    
    private func makePhotoLibraryRequest() {
        PHPhotoLibrary.requestAuthorization { (status) in
        }
    }
    
    //MARK: authCameraRequest
    
    private func handleCameraRequest() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            openCamera()
        case .denied,.restricted:
            ProgressHUD.showError("To open camera you need to get access in settings.".localized())
        default:
            makeCameraRequest()
        }
    }
    
    private func makeCameraRequest() {
        AVCaptureDevice.requestAccess(for: .video) { (status) in
            
        }
    }
    
    private func showConfirmAlert() {
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Detection preprocess".localized(), message: "Are you sure to start detecting process?".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start".localized(), style: .default, handler: { [weak self] (action) in
            guard let sSelf = self, !sSelf.pickedImages.isEmpty else {
                return
            }
            sSelf.showRecognizedVC()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showRecognizedVC() {
        let recognizedVC = StorybardService.main.viewController(viewControllerClass: RecognizedViewController.self)
        recognizedVC.modalPresentationStyle = .fullScreen
        recognizedVC.pickedImages = pickedImages
        present(recognizedVC, animated: true, completion: nil)
    }
    
    
}

//MARK: - AssetsPickerViewControllerDelegate, UINavigationControllerDelegate

extension ScanningViewController: AssetsPickerViewControllerDelegate, UINavigationControllerDelegate {
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        pickedImages = assets.map({$0.getAssetThumbnail()})
        controller.photoViewController.deselectAll()
        
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        controller.photoViewController.deselectAll()
    }
}

extension ScanningViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImages = [image]
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
