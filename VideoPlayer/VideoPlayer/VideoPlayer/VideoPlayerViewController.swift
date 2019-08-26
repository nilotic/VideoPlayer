//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import UIKit
import AVKit

final class VideoPlayerViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private var playerView: UIView!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var fullScreenButton: UIButton!
    @IBOutlet private var qualityButton: UIButton!
    
    @IBOutlet private var previousButton: UIButton!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var nextButton: UIButton!
    
    @IBOutlet private var currentTimeLabel: UILabel!
    @IBOutlet private var timeSlider: UISlider!
    @IBOutlet private var totalTimeLabel: UILabel!
    @IBOutlet private var captionSettingView: UIView!
    @IBOutlet private var captionSettingButton: UIButton!
    @IBOutlet private var captionSettingabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    
    
    
    // MARK: - Value
    // MARK: Public
    let dataManager = VideoPlayerDataManager()
    
    
    
    // MARK: Private
    private lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: dataManager.player)
        playerLayer.videoGravity  = .resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        playerLayer.bounds        = playerView.bounds
        
        playerLayer.addSublayer(playerLayer)
        return playerLayer
    }()
    
    private var timeObserver: Any? = nil
    
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.bounds = playerView.bounds
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func close() {
        
    }
    
    
    
    
    // MARK: - Event
    @IBAction private func fullScreenButtonTouUpInside(_ sender: UIButton) {
    
    }
    
    @IBAction private func qualityButtonTouchUpInside(_ sender: UIButton) {
    
    }
    
    @IBAction private func previousButtonTouchUpInside(_ sender: UIButton) {
    
    }
    
    @IBAction private func playButtonTouchUpInside(_ sender: UIButton) {
    
    }
    
    @IBAction private func nextButtonTouchUpInside(_ sender: UIButton) {
    
    }
    
    @IBAction private func captionSettingButtonTouchUpInside(_ sender: UIButton) {
        
    }
    
    @IBAction private func closeButtonTouchUpInside(_ sender: UIButton) {
        close()
    }
}
