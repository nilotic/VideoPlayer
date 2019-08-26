//
//  SignedCookie.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import Foundation

struct SignedCookie {
    let policy: String
    let signature: String
    let keyPairID: String
}

extension SignedCookie: Codable {
    
    private enum Key: String, CodingKey {
        case policy    = "CloudFront-Policy"
        case signature = "CloudFront-Signature"
        case keyPairID = "CloudFront-Key-Pair-Id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { policy    = try container.decode(String.self, forKey: .policy) }    catch { throw DecodingError.keyNotFound(Key.policy, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a policy.")) }
        do { signature = try container.decode(String.self, forKey: .signature) } catch { throw DecodingError.keyNotFound(Key.signature, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a signature.")) }
        do { keyPairID = try container.decode(String.self, forKey: .keyPairID) } catch { throw DecodingError.keyNotFound(Key.keyPairID, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a keyPairID.")) }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(policy,    forKey: .policy) }    catch {}
        do { try container.encode(signature, forKey: .signature) } catch {}
        do { try container.encode(keyPairID, forKey: .keyPairID) } catch {}
    }
}
