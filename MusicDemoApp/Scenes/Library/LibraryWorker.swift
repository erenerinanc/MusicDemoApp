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
        musicAPI.getLibraryPlaylist { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTopCharts(_ completion: @escaping (Result<TopCharts, Error>) -> Void) {
        musicAPI.getTopCharts(with: storeFrontID) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
