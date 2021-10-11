//
//  SearchResultsWorker.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation
import AVFoundation

protocol SearchResultsWorkingLogic: AnyObject {
    func getSearchResults(request: SearchResults.Fetch.Request,_ completion: @escaping (Result<Search,Error>) -> Void)
}

final class SearchResultsWorker: SearchResultsWorkingLogic {
    
    let musicAPI: AppleMusicAPI
    let storeFrontID: String
    init(musicAPI: AppleMusicAPI, storeFrontID: String) {
        self.musicAPI = musicAPI
        self.storeFrontID = storeFrontID
    }
    
    func getSearchResults(request: SearchResults.Fetch.Request, _ completion: @escaping (Result<Search, Error>) -> Void) {
        musicAPI.fetch(request: APIRequest.searchSongsOrArtists(storeFrontID: storeFrontID, by: request.searchQuery), model: Search.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
