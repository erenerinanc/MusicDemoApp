//
//  AppleMusicAPI.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 23.09.2021.
//

import Foundation
import StoreKit

final class AppleMusicAPI {
    static let shared = AppleMusicAPI()
    private init() {}
    
    let developerToken = JWT.shared.generateToken()
    
    func getUserToken() -> String {
        var userToken = String()
        
        let lock = DispatchSemaphore(value: 0)
        
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { receivedToken, error in
            guard error == nil else { return }
            if let token = receivedToken {
                userToken = token
                
                //If not called, the app will forever remain stuck until the user restarts the app.
                lock.signal()
            }
        }
        
        //This tells the code to halt executing any further code until a signal is given.
        lock.wait()
        
        return userToken
    }
    
    func fetch<T:Decodable>(_ completion: @escaping (Result<T,Error>) -> Void) {
        
    }
}
