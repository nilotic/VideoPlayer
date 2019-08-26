//
//  API.swift
//  weverse
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation
import UIKit

var weverseHost: Host = .userHost(server: .stage)

enum Host {
    enum Server {
        case development
        case stage
        case production
    }
    
    case userHost(server: Server)
    case pallycon
}

extension Host: CustomDebugStringConvertible {
    
    // Raw value
    var rawValue: String {
        switch self {
        case .userHost(let server):
            switch server {
            case .development:  return "https://www.naver.com"
            case .stage:        return "https://www.naver.com"
            case .production:   return "https://www.naver.com"
            }
            
        case .pallycon:         return "https://www.naver.com"
        }
    }
    
    
    // URL
    var url: URL {
        return URL(string: self.rawValue)!
    }
    
    
    var debugDescription: String {
        return ""
    }
}


enum API {
    case mediaToken
    case mediaLicense
    case mediaCertificate
}

extension API {
    
    var url: URL {
        switch self {
        case .mediaToken:           return URL(string: "\(weverseHost.rawValue)/")!
        case .mediaLicense:         return URL(string: "\(Host.pallycon.rawValue)/")!
        case .mediaCertificate:     return URL(string: "\(Host.pallycon.rawValue)/")!
        }
    }
}
