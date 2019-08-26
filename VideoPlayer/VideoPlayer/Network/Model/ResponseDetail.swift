//
//  ResponseDetail.swift
//  weverse
//
//  Created by Den Jo on 08/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct ResponseDetail {
    var statusCode: HTTPStatusCode?
    let message: String?
    var code: Int?
}

extension ResponseDetail {
    
    init(message: String?) {
        self.message = message
        code = nil
    }
    
    init(statusCode: HTTPStatusCode?,  message: String?) {
        self.statusCode = statusCode
        self.message    = message
        code = nil
    }
}

extension ResponseDetail: Decodable {
    
    private enum Key: String, CodingKey {
        case message
        case code
        case errorCode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { message = try container.decode(String.self, forKey: .message) }    catch { message = nil }
        do { code    = try container.decode(Int.self,    forKey: .code) }       catch { code = nil }
        
        if code == nil {
             do { code = try container.decode(Int.self, forKey: .errorCode) } catch { code = nil }
        }
    }
}
