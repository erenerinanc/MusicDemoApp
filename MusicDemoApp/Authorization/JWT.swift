//
//  JWT.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation
import SwiftJWT

class JWT {
    static let shared = JWT()
    private init() {}
    
    let teamID = "RE9892F24F"
    let keyID = "J766FNQUAL"
    let authToken = """
        -----BEGIN PRIVATE KEY-----
        MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgnK4yCkJg0X5XpyNV
        uqu1BoXcMdZMq/kxYpXVOICriSOgCgYIKoZIzj0DAQehRANCAASLXcfXS1YywpHN
        dFlexEieaFJoZy3KPEqHK+uB7JNoBI1uYFfLlqAvfAIANQ2QrVwGbdcGZyySptma
        R67v9MnJ
        -----END PRIVATE KEY-----
        """
    
    func generateToken() -> String {
        let header = Header(kid: keyID)
        let claims = JWTClaims(iss: teamID, iat: Date(), exp: Date()
        + 60 * 60 * 24 * 180)
        var jwt = SwiftJWT.JWT(header: header, claims: claims)
        
        guard let tokenData = authToken.data(using: .utf8) else { return ""}
        
        do {
            let token = try jwt.sign(using: .es256(privateKey: tokenData))
            return token
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
}

struct JWTClaims: Claims {
    let iss: String?
    let iat: Date?
    let exp: Date?
}
