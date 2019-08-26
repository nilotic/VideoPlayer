//
//  Language.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import Foundation

struct Language: Equatable, Hashable {
    let code: LanguageCode
}

extension Language {
    
    init?(languageCode: String?) {
        guard let languageCode = languageCode, let code = LanguageCode(rawValue: languageCode) else { return nil }
        self.code = code
    }
    
    var localizedString: String? {
        switch code {
        case .chinese(.simplified):     return "中文(简体)"
        case .chinese(.traditional):    return "中文(繁体)"
        case .indonesian:               return "Bahasa Indonesia"
        case .malay:                    return "Bahasa Melayu"
        case .spanish:                  return "Español"
        case .portuguese:               return "Português"
        case .thai:                     return "ภาษาไทย"
        default:                        return Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue : code.rawValue])).localizedString(forIdentifier: code.rawValue)
        }
    }
}

extension Language: Codable {
    
    private enum Key: String, CodingKey {
        case languageCode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(code.rawValue, forKey: .languageCode) } catch { throw error }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do {
            guard let languageCode = LanguageCode(rawValue: try container.decode(String.self, forKey: .languageCode)) else {
                throw DecodingError.keyNotFound(Key.languageCode, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a language code."))
            }
            code = languageCode
            
        } catch { throw DecodingError.keyNotFound(Key.languageCode, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a language code.")) }
    }
}
