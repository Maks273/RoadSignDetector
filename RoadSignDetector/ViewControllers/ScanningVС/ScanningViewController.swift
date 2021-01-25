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

class ScanningViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var openGalleryBtn: UIButton!
    @IBOutlet weak var openCameraBtn: UIButton!
    
    //MARK: - Variables
    
    private var imagePicker = UIImagePickerController()
    private var pickedImage: UIImage? {
        didSet {
            showConfirmAlert()
        }
    }
    private let detectionService = DetectionService()
//    /private let scanningHelper = ScanningVCHelper()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyleForOpenButtons()
        configureImagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        NotificationCenter.default.addNetworkObserver(in: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
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
    
    private func showConfirmAlert() {
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Detection preprocess", message: "Are you sure to start detecting process?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start", style: .default, handler: { [weak self] (action) in
            guard let sSelf = self, let image = sSelf.pickedImage else {
                return
            }
            ProgressHUD.show()
            sSelf.detectionService.updateClassification(for: image)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showRecognizedVC(with results: [VNRecognizedObjectObservation]) {
        let recognizedVC = StorybardService.main.viewController(viewControllerClass: RecognizedViewController.self)
        recognizedVC.image = pickedImage
        recognizedVC.modalPresentationStyle = .fullScreen
        recognizedVC.setRecognizedResults(results)
        present(recognizedVC, animated: true, completion: nil)
    }
    
    //MARK: recognistion observer
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(recognizingCompleted(_:)), name: Notification.Name("recognitionCompleted"), object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("recognitionCompleted"), object: nil)
    
    }
    
    @objc private func recognizingCompleted(_ notification: Notification) {
        guard let results = notification.userInfo?["results"] as? [VNRecognizedObjectObservation] else {
            return
        }
        showRecognizedVC(with: results)
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ScanningViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImage = image
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
