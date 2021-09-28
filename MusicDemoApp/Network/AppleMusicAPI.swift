//
//  AppleMusicAPI.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 23.09.2021.
//

import Foundation
import StoreKit
import SwiftyJSON


enum EndPoints {
    static let rootPath = "https://api.music.apple.com/v1/"
    static let storeFront = "https://api.music.apple.com/v1/me/storefront"
    static let libraryPlaylist = "https://api.music.apple.com/v1/me/library/playlists"
    
}

var placeHolderImageURL: URL = URL(string: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg")!

protocol StoreFront {
    func getUserStorefront(_ completion: @escaping (Result<Storefront,Error>) -> Void) -> String
}

protocol LibraryPlaylist {
    func getLibraryPlaylist(_ completion: @escaping (Result<Playlists,Error>) -> Void )
}

final class AppleMusicAPI {
    let urlSession: URLSession
    
    //For testability
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    init(developerToken: String, userToken: String) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "Authorization": "Bearer \(developerToken)",
            "Music-User-Token": userToken
        ]
        
        urlSession = URLSession(configuration: sessionConfig)
    }
    
}

enum APIError: Error {
    case noResponse
}

extension AppleMusicAPI: StoreFront {
    func getUserStorefront(_ completion: @escaping (Result<Storefront,Error>) -> Void) -> String {
        var storefrontID = ""
        let storeFrontURL = URL(string: EndPoints.storeFront)!
        var storeFrontRequest = URLRequest(url: storeFrontURL)
        storeFrontRequest.httpMethod = "GET"
        urlSession.dataTask(with: storeFrontRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            print("API Request HTTP Status Code:", urlResponse.statusCode)
            
            guard urlResponse.statusCode == 200 else {
                print("API Response is not OK")
                completion(.failure(APIError.noResponse))
                return
            }
            
            guard let data = data else {
                print("API Response has no data")
                completion(.failure(APIError.noResponse))
                return
            }
            
            do {
                let storeFrontResponse = try JSONDecoder().decode(Storefront.self, from: data)
                completion(.success(storeFrontResponse))
                guard let storefrontdata = storeFrontResponse.data?[0] else { return }
                guard let storefrontid = storefrontdata.id else { return }
                storefrontID = storefrontid
            } catch {
                print("Failed to decode storefront ID", error.localizedDescription)
            }
            
        }.resume()
        
        return storefrontID
    }
}

extension AppleMusicAPI: LibraryPlaylist {
    func getLibraryPlaylist(_ completion: @escaping (Result<Playlists, Error>) -> Void) {
        let playlistURL = URL(string: EndPoints.libraryPlaylist)!
        var playlistRequest = URLRequest(url: playlistURL)
        playlistRequest.httpMethod = "GET"
        
        urlSession.dataTask(with: playlistURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            
            print("API Request HTTP Status Code:", urlResponse.statusCode)
            guard urlResponse.statusCode == 200 else {
                print("API Response is not OK")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("API Response is:", responseString)
                }
                
                completion(.failure(APIError.noResponse))
                return
            }
            
            guard let data = data else {
                print("API Response has no data")
                completion(.failure(APIError.noResponse))
                return
            }
            
            let response = String(data: data, encoding: .utf8)!
            print("API Response is:", response)
            
            do {
                let playlists = try JSONDecoder().decode(Playlists.self, from: data)
                completion(.success(playlists))
            } catch {
                let error = error
                print("Failed to decode Playlists object:", error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
}

  
    
