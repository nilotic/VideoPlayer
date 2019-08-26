//
//  VideoAsset.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import Foundation
import AVFoundation

struct VideoAsset {
    let urlAsset: AVURLAsset
    let name: String
    let downloadState: DownloadState = .notDownloaded
}

extension VideoAsset {
    enum DownloadState: String {
        case notDownloaded
        case downloading
        case downloaded
    }
}

extension VideoAsset {
    
    struct Keys {
        /// Key for the Asset name, used for `AssetDownloadProgressNotification` and `AssetDownloadStateChangedNotification` Notifications as well as AssetListManager.
        static let name = "AssetNameKey"
        
        /// Key for the Asset download percentage, used for `AssetDownloadProgressNotification` Notification.
        static let percentDownloaded = "AssetPercentDownloadedKey"
        
        /// Key for the Asset download state, used for `AssetDownloadStateChangedNotification` Notification.
        static let downloadState = "AssetDownloadStateKey"
        
        /// Key for the Asset download AVMediaSelection display Name, used for `AssetDownloadStateChangedNotification` Notification.
        static let downloadSelectionDisplayName = "AssetDownloadSelectionDisplayNameKey"
    }
}

extension VideoAsset: Equatable {
    
    static func ==(lhs: VideoAsset, rhs: VideoAsset) -> Bool {
        return lhs.urlAsset == rhs.urlAsset
    }
}
