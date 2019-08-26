//
//  URLRequestExtension.swift
//  weverse
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation
import UIKit

extension URLRequest {
    
    // MARK: - Initializer
    init?(request: URLRequest) {
        guard let url = request.url, let httpMethod = HTTPMethod(request: request) else { return nil }
        self.init(httpMethod: httpMethod, url: url)
    }
    
    init(httpMethod: HTTPMethod, url: API) {
        self.init(httpMethod: httpMethod, url: url.url)
    }
    
    init(httpMethod: HTTPMethod, url: URL) {
        self.init(url: url)
        
        // Set request
        self.httpMethod = httpMethod.rawValue
        timeoutInterval = 90.0
        
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let appVersion       = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        let userAgent        = "AppName weverse; OS iOS; BundleIdentifier \(bundleIdentifier); AppVersion \(appVersion); SystemVersion \(UIDevice.current.systemVersion); DeviceModel \(UIDevice.current.model);"
        
        setValue(userAgent,         forHTTPHeaderField: "User-Agent")
        setValue("gzip",            forHTTPHeaderField: "Accept-Encoding")
    }
    
    
    // MARK: - Function
    mutating func addValue(value: HTTPHeaderValue, field: HTTPHeaderField) {
        addValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func addValue(value: String, field: HTTPHeaderField) {
        addValue(value, forHTTPHeaderField: field.rawValue)
    }
}
