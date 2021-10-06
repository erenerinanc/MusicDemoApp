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
    static let search = "https://api.music.apple.com/v1/catalog/{storefront}/search"
    static let topCharts = "https://api.music.apple.com/v1/catalog/{storefront}/charts?types=songs"
    static let catalogPlaylist = "https://api.music.apple.com/v1/catalog/{storefront}/playlists/{globalID}"
    
}

protocol StoreFront {
    func getUserStorefront(_ completion: @escaping (Result<Storefront,Error>) -> Void)
}

protocol LibraryPlaylist {
    func getLibraryPlaylist(_ completion: @escaping (Result<Playlists,Error>) -> Void )
}

//protocol SearchLogic {
//    func getSongsOrArtists(with storefrontID: String,_ completion: @escaping (Result<SearchResponse,Error>) -> Void )
//}

protocol TopChart {
    func getTopCharts(with storeFrontId: String, _ completion: @escaping (Result<TopCharts,Error>) -> Void)
}

protocol GetCatalogPlaylist {
    func getCatalogPlaylist(storeFrontId: String,globalId: String,_ completion: @escaping (Result<CatalogPlaylist,Error>) -> Void)
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
    func getUserStorefront(_ completion: @escaping (Result<Storefront,Error>) ->Void) {
        let storeFrontURL = URL(string: EndPoints.storeFront)!
        var storeFrontRequest = URLRequest(url: storeFrontURL)
        storeFrontRequest.httpMethod = "GET"
        urlSession.dataTask(with: storeFrontRequest) { data, response, error in
            guard error == nil else { return }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            
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
            } catch {
                print("Failed to decode storefront ID", error.localizedDescription)
            }
            
        }.resume()
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

//extension AppleMusicAPI: SearchLogic {
//    func getSongsOrArtists(with storefrontID: String, _ completion: @escaping (Result<SearchResponse, Error>) -> Void) {
//        let searchURLString = EndPoints.search.replacingOccurrences(of: "{storefront}", with: storefrontID)
//        let searchURL = URL(string: searchURLString)!
//        var searchRequest = URLRequest(url: searchURL)
//        searchRequest.httpMethod = "GET"
//
//        urlSession.dataTask(with: searchRequest) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            guard let urlResponse = response as? HTTPURLResponse else {
//                completion(.failure(APIError.noResponse))
//                return
//            }
//            print("API Request HTTP Status Code:", urlResponse.statusCode)
//            guard urlResponse.statusCode == 200 else {
//                print("API Response is not OK")
//                if let data = data, let responseString = String(data: data, encoding: .utf8) {
//                    print("API Response is:", responseString)
//                }
//                completion(.failure(APIError.noResponse))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noResponse))
//                return
//            }
//            do {
//                let searchResult = try JSONDecoder().decode(SearchResponse.self, from: data)
//                completion(.success(searchResult))
//            } catch {
//                print("Failed to decode Search Result", error.localizedDescription)
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}

extension AppleMusicAPI: TopChart {
    func getTopCharts(with storeFrontID: String,_ completion: @escaping (Result<TopCharts, Error>) -> Void) {
        let topchartURLString = EndPoints.topCharts.replacingOccurrences(of: "{storefront}", with: storeFrontID)
        let url = URL(string: topchartURLString)!
        var topchartRequest = URLRequest(url: url)
        topchartRequest.httpMethod = "GET"
        
        urlSession.dataTask(with: topchartRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            guard response.statusCode == 200 else {
                completion(.failure(APIError.noResponse))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noResponse))
                return
            }
            do {
                let result = try JSONDecoder().decode(TopCharts.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
}

extension AppleMusicAPI: GetCatalogPlaylist {
    func getCatalogPlaylist(storeFrontId: String, globalId: String, _ completion: @escaping (Result<CatalogPlaylist, Error>) -> Void) {
        let catalogURLString = EndPoints.catalogPlaylist.replacingOccurrences(of: "{storefront}", with: storeFrontId).replacingOccurrences(of: "{globalID}", with: globalId)
        let url = URL(string: catalogURLString)!
        var catalogRequest = URLRequest(url: url)
        catalogRequest.httpMethod = "GET"
        
        urlSession.dataTask(with: catalogRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            guard response.statusCode == 200 else {
                completion(.failure(APIError.noResponse))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noResponse))
                return
            }
            do {
                let result = try JSONDecoder().decode(CatalogPlaylist.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
  
    
