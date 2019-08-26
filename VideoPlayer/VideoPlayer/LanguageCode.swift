//
//  LanguageCode.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import Foundation

enum LanguageCode: Equatable {
    case english(English)
    case chinese(Chinese)
    case korean
    case japanese
    case indonesian
    case malay
    case spanish
    case portuguese
    case thai
    
    enum English {
        case none
        case us
        case uk
        case australian
        case canadian
        case indian
    }
    
    enum Chinese {
        case simplified
        case traditional
        case hongKong
    }
}

extension LanguageCode {
    
    init?(rawValue: String?) {
        guard let rawValue = rawValue else { return nil }
        
        switch rawValue {
        case "en":          self = .english(.none)
        case "en-US":       self = .english(.us)
        case "en-GB":       self = .english(.uk)
        case "en-AU":       self = .english(.australian)
        case "en-CA":       self = .english(.canadian)
        case "en-IN":       self = .english(.indian)
            
        case "zh-Hans":     self = .chinese(.simplified)
        case "zh-Hant":     self = .chinese(.traditional)
        case "zh-HK":       self = .chinese(.hongKong)
        case "zh-CN":       self = .chinese(.simplified)
        case "zh-TW":       self = .chinese(.traditional)
            
        case "ko":          self = .korean
        case "ja":          self = .japanese
        case "id":          self = .indonesian
        case "ms":          self = .malay
        case "es":          self = .spanish
        case "pt":          self = .portuguese
        case "th":          self = .thai
        default:            return nil
        }
    }
}

extension LanguageCode: Hashable {
    
    var rawValue: String {
        switch self {
        case .english(let english):
            switch english {
            case .none:              return "en"
            case .us:                return "en-US"
            case .uk:                return "en-GB"
            case .australian:        return "en-AU"
            case .canadian:          return "en-CA"
            case .indian:            return "en-IN"
            }
            
        case .chinese(let chinese):
            switch chinese {
            case .simplified:       return "zh-CN"
            case .traditional:      return "zh-TW"
            case .hongKong:         return "zh-HK"
            }
            
        case .korean:               return "ko"
        case .japanese:             return "ja"
        case .indonesian:           return "id"
        case .malay:                return "ms"
        case .spanish:              return "es"
        case .portuguese:           return "pt"
        case .thai:                 return "th"
        }
    }
}

extension LanguageCode: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        guard let code = LanguageCode(rawValue: try container.decode(String.self)) else { throw DecodingError.valueNotFound(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a languageCode.")) }
        self = code
    }
}
