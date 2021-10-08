//
//  LibraryWorker.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryWorkingLogic: AnyObject {
    func fetchPlaylists(_ completion: @escaping (Result<Playlists, Error>) -> Void)
    func fetchTopCharts(_ completion: @escaping (Result<TopCharts, Error>) -> Void)
}

final class LibraryWorker: LibraryWorkingLogic {
  
    let musicAPI: AppleMusicAPI
    let storeFrontID: String
    init(musicAPI: AppleMusicAPI, storeFrontID: String) {
        self.musicAPI = musicAPI
        self.storeFrontID = storeFrontID
    }
    
    func fetchPlaylists(_ completion: @escaping (Result<Playlists, Error>) -> Void) {
        musicAPI.fetch(request: APIRequest.getLibraryPlaylists(), model: Playlists.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchTopCharts(_ completion: @escaping (Result<TopCharts, Error>) -> Void) {
        musicAPI.fetch(request: APIRequest.getTopCharts(with: storeFrontID), model: TopCharts.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
