//
//  Response.swift
//  weverse
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct Response {
    let data: Data?
    let urlResponse: HTTPURLResponse?
    let detail: ResponseDetail?
    let error: Error?
}

extension Response {
    
    init(data: Data?, urlResponse: HTTPURLResponse?, error: Error?) {
        self.data        = data
        self.urlResponse = urlResponse
        self.error       = error
        
        guard let data = data, var responseDetail = try? JSONDecoder().decode(ResponseDetail.self, from: data) else {
            detail = ResponseDetail(statusCode: HTTPStatusCode(rawValue: urlResponse?.statusCode ?? 0), message: NSLocalizedString("Please check your network connection or try again.", comment: "") )
            return
        }
        responseDetail.statusCode = HTTPStatusCode(rawValue: urlResponse?.statusCode ?? 0)
        detail = responseDetail
    }
}
