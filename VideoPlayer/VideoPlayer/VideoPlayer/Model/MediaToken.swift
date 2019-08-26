//
//  MediaToken.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import Foundation

struct MediaToken: Encodable {
    let id: Int64   //video id
    let token: String
    let signedCookie: SignedCookie?
    let expiresIn: TimeInterval
}

extension MediaToken {

    init(id: Int64, data: MediaTokenResponse) {
        self.id = id
        
        token        = data.token
        signedCookie = data.signedCookie
        expiresIn    = data.expiresIn
    }
}
