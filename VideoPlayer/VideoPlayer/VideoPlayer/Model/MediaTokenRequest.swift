//
//  ServerPlaybackContextRequest.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import Foundation

struct MediaTokenRequest {}

extension MediaTokenRequest: Encodable {
    
    private enum Key: String, CodingKey {
        case drmType
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode("FairPlay", forKey: .drmType) } catch { throw error }
    }
}
