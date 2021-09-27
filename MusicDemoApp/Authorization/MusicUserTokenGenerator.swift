//
//  MusicUserTokenGenerator.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 26.09.2021.
//

import Foundation
import StoreKit

final class UserToken {
    let developerToken: String
    init(developerToken: String) {
        self.developerToken = developerToken
    }
    
    func generateToken(_ completion: @escaping (Result<String,Error>) -> Void) {
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { token, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            if let userToken = token {
                completion(.success(userToken))
            }
 
        }
    }
    
}
