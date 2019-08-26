//
//  ServerPlaybackContextResponse.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import Foundation

struct MediaTokenResponse: Decodable {
    let token: String
    let expiresIn: TimeInterval
    let signedCookie: SignedCookie
}
