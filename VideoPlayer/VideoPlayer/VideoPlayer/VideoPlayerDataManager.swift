//
//  VideoPlayerDataManager.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import UIKit
import AVKit

// MARK: - Define
struct VideoPlayerNotificationName {
    static let video = Notification.Name("VideoPlayerNotification")
}

final class VideoPlayerDataManager: NSObject {

    // MARK: - Value
    // MARK: Public
    private(set) var player  = AVQueuePlayer()
    private(set) var streams = [VideoAsset]()
//    private(set) var tokens  = [MediaToken]()
    
  
    // MARK: Private
    private var playerItemObserver: NSKeyValueObservation? = nil
    private var urlAssetObserver: NSKeyValueObservation?   = nil
    private var playerRateObserver: NSKeyValueObservation? = nil
    private var timeObserver: Any?                         = nil
    private var token: MediaToken?                         = nil
    
    
    private var playerItem: AVPlayerItem? {
        didSet {
            NotificationCenter.default.removeObserver(self)
            playerItemObserver?.invalidate()
            playerItemObserver = nil
            
            
            guard let playerItem = playerItem else { return }
            playerItem.preferredForwardBufferDuration = 1
            playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true
            
            playerItemObserver = playerItem.observe(\AVPlayerItem.status, options: [.new, .initial]) { [weak self] (item, value) in
                guard self != nil else { return }
                
                switch item.status {
                case .readyToPlay:
                    log(.info, "readyToPlay")
//                    self?.playerStatus = .readyToPlay
                    
                case .failed:
                    log(.error, "\(item.error?.localizedDescription ?? "") \(item.errorLog()?.events.last?.description ?? "")")
                    
//                    self?.playerStatus = .failed
//                    NotificationCenter.default.post(name: MediaPlaybackNotificationName.error, object: item.error)
                    
                default:
                    break
                }
            }
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlayerItem(notification:)), name: .AVPlayerItemDidPlayToEndTime,      object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlayerItem(notification:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlayerItem(notification:)), name: .AVPlayerItemPlaybackStalled,       object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlayerItem(notification:)), name: .AVPlayerItemNewAccessLogEntry,     object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlayerItem(notification:)), name: .AVPlayerItemNewErrorLogEntry,      object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didReceivePlayerItem(notification:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        }
    }
    
    private var asset: VideoAsset? {
        didSet {
            urlAssetObserver?.invalidate()
            urlAssetObserver = nil
            
            guard let asset = asset else {
                playerItem = nil
                player.replaceCurrentItem(with: nil)
                return
            }
            
            urlAssetObserver = asset.urlAsset.observe(\AVURLAsset.isPlayable, options: [.new, .initial]) { [weak self] (urlAsset, _) in
                guard self != nil, urlAsset.isPlayable == true else { return }
                
                self?.playerItem = AVPlayerItem(asset: urlAsset)
                self?.player.replaceCurrentItem(with: self?.playerItem)
            }
        }
    }
    
    
    // MARK: - Initializer
    override init() {
        super.init()
        
        playerRateObserver = player.observe(\AVQueuePlayer.rate, options: [.new, .initial]) {  [weak self] (player, value) in
            log(.info, "\(player) \(value)")
        }
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 600), queue: .main) { [weak self] time in
            //            guard let duration = self.player.currentItem?.duration, duration.isValid == true, self.playerStatus != .finished else { return }
            
            log(.info, time)
        }
        
        player.appliesMediaSelectionCriteriaAutomatically = true
        player.automaticallyWaitsToMinimizeStalling       = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        playerItemObserver?.invalidate()
        playerItemObserver = nil
        
        urlAssetObserver?.invalidate()
        urlAssetObserver = nil
        
        playerRateObserver?.invalidate()
        playerRateObserver = nil
    }
    
    
    
    // MARK: - Function
    // MARK: Public
    func requestVideo() -> Bool {
        return requestToken()
    }
    
    
    // MARK: Private
    private func requestToken() -> Bool {
        let request = URLRequest(httpMethod: .get, url: .mediaToken)
        
        return NetworkManager.shared.request(urlRequest: request, requestData: MediaTokenRequest()) { (_, response) in
            var errorDetail: ResponseDetail? = nil
            defer { DispatchQueue.main.async { NotificationCenter.default.post(name: VideoPlayerNotificationName.video , object: errorDetail) } }
            
            // Handle data
            guard let decodableData = response?.data else {
                errorDetail = response?.detail
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(MediaTokenResponse.self, from: decodableData)
                DispatchQueue.main.async {
                    self.token = MediaToken(id: 1, data: tokenResponse)
                    
                }
                
            } catch {
                log(.error, error.localizedDescription)
                errorDetail = response?.detail
                return
            }
        }
    }
    
    private func requestResources() -> Bool {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "resourceQueue")
        
        var captions = [Captions]()
        
        // Subtitle
        if let captions = videoMedia?.video?.captionS3Paths {
            for caption in captions {
                group.enter()
                if self.requestExternalSubtitle(url: caption.captionFilePath, completion: { captions in
                    defer { group.leave() }
                    
                    guard let captions = captions else { return }
                    queue.async { subtitles.append(ExternalSubtitle(language: caption.language, captions: captions)) }
                    
                }) == false {
                    group.leave()
                }
            }
        }
        
        // Video Quality
        if let hlsPath = videoMedia?.video?.hlsPath, let hlsURL = URL(string: hlsPath) {
            group.enter()
            if self.requestManifest(url: hlsURL, completion: { playlist in
                DispatchQueue.main.async { self.masterPlaylist = playlist }
                group.leave()
                
            }) == false {
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.subtitles = subtitles
                self.selectedSubtitle = subtitles.first(where: { $0.language.code == LocaleManager.language?.code })
                NotificationCenter.default.post(name: MediaDetailNotificationName.subtitle, object: nil)
            }
        }
        
        return true
    }
    
    // MARK: - Notification
    @objc private func didReceivePlayerItem(notification: Notification) {
        switch notification.name {
        case .AVPlayerItemDidPlayToEndTime:
            log(.info, notification.name)
//            guard let currentItem = player.currentItem else { return }
//
//            delegate?.mediaPlayer(currentDuration: currentItem.duration.seconds, totalDuration: currentItem.duration.seconds)
//            delegate?.mediaPlayer(changedPlayer: .finished)
//
//            playerStatus = .finished
            
            
        case .AVPlayerItemFailedToPlayToEndTime:
            log(.info, notification.name)
            
        case .AVPlayerItemPlaybackStalled:
            log(.info, notification.name)

        case .AVPlayerItemNewAccessLogEntry:
            guard let lastEvent = playerItem?.accessLog()?.events.last else { return }
            log(.info, lastEvent.debugDescription)

        case .AVPlayerItemNewErrorLogEntry:
            guard let events = playerItem?.errorLog()?.events else { return }
            events.forEach { log(.error, "\($0.errorDomain): \($0.errorStatusCode) - \($0.errorComment ?? "") |  \((notification.object as? Error)?.localizedDescription ?? "")") }

        case .AVPlayerItemFailedToPlayToEndTime:
            guard let error = notification.object as? Error, let userInfo = notification.userInfo else { return }
            log(.error, "\(error.localizedDescription)\n\(userInfo)")

        default:
            log(.info, notification.name)
        }
    }
}
