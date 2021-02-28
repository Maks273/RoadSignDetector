//
//  LanguageView.swift
//  RoadSignDetector
//
//  Created by Макс Пайдич on 29.11.2020.
//  Copyright © 2020 Макс Пайдич. All rights reserved.
//

import UIKit

class AudioView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var playSoundLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var voiceSegmentedControll: UISegmentedControl! {
        didSet {
            voiceSegmentedControll.selectedSegmentIndex = getCurrentVoiceIndex()
        }
    }
    @IBOutlet weak var audioSwitcher: UISwitch! {
        didSet {
            audioSwitcher.isOn = loadCurrentAudioStatus()
        }
    }
    @IBOutlet weak var settingsView: SettingsView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var verticalLine: UIView!
    
    //MARK: - Variables
    
    private let manVoiceSegmentIndex = 0
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AudioView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        updateLocalization()
        setupStyle()
    }
    
    private func updateLocalization() {
        playSoundLabel.localizedText()
        voiceLabel.localizedText()
        voiceSegmentedControll.setTitle("Man".localized(), forSegmentAt: 0)
        voiceSegmentedControll.setTitle("Woman".localized(), forSegmentAt: 1)
    }
    
    private func setupStyle() {
        bottomContainerView.setShadow(with: 30)
        verticalLine.defalutVerticalLine(with: [.layerMinXMaxYCorner], cornerRadius: 5)
    }
    
    //MARK: Speaker Voice
    
    private func getCurrentVoiceIndex() -> Int {
        return Environment.shared.loadCurrentVoice() == VoiceType.man.rawValue || Environment.shared.loadCurrentVoice() == "" ? 0 : 1
    }
    
    //MARK: Audio Status
    
    private func saveCurrentAudioStatus(_ status: Bool) {
        Environment.shared.savePlaySoundStatus(status)
    }
    
    private func loadCurrentAudioStatus() -> Bool {
        return Environment.shared.loadPlaySoundStatus()
    }
        
    //MARK: - IBActions
    
    @IBAction func soundSwitcherWasToggled(_ sender: UISwitch) {
        saveCurrentAudioStatus(sender.isOn)
        Environment.shared.changePlaySoundStatus()
    }
    
    @IBAction func voiceWasToggled(_ sender: UISegmentedControl) {
        Environment.shared.saveCurrentVoice(sender.selectedSegmentIndex == manVoiceSegmentIndex ? VoiceType.man.rawValue : VoiceType.woman.rawValue)
        Environment.shared.changeCurrentVoiceType()
    }
}
