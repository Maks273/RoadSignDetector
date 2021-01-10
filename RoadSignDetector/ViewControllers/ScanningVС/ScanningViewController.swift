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

class ScanningViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var openGalleryBtn: UIButton!
    @IBOutlet weak var openCameraBtn: UIButton!
    
    
    //MARK: - Variables
    
    private var imagePicker = UIImagePickerController()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyleForOpenButtons()
        configureImagePicker()
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
    
    private func configureImagePicker() {
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
    }
    
    private func showImagePicker(by type: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imagePicker.sourceType = type
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: PhotoLibraryRequest
    
    private func handlePhotoLibraryRequestStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            showImagePicker(by: .photoLibrary)
        case .denied, .restricted:
            ProgressHUD.showError("To open photos you need to get access in settings.")
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
            showImagePicker(by: .camera)
        case .denied,.restricted:
            ProgressHUD.showError("To open camera you need to get access in settings.")
        default:
            makeCameraRequest()
        }
    }
    
    private func makeCameraRequest() {
        AVCaptureDevice.requestAccess(for: .video) { (status) in
            
        }
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ScanningViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("didFinishPickingMediaWithInfo")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
    }
    
}
