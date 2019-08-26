//
//  HTTPMethod.swift
//  weverse
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case put    = "PUT"
    case post   = "POST"
    case get    = "GET"
    case delete = "DELETE"
}

extension HTTPMethod {
    
    init?(request: URLRequest?) {
        guard let string = request?.httpMethod, let method = HTTPMethod(rawValue: string) else { return nil }
        self = method
    }
}
