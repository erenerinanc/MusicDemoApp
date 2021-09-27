//
//  LibraryWorker.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryWorkingLogic: AnyObject {
    func fetchStorefrontID(_ completion: @escaping (Result<Storefront, Error>) -> Void)
    func fetchPlaylists(_ completion: @escaping (Result<Playlists, Error>) -> Void)
}

final class LibraryWorker: LibraryWorkingLogic {
  
    let musicAPI: AppleMusicAPI
    init(musicAPI: AppleMusicAPI) {
        self.musicAPI = musicAPI
    }
    
    //gonna use it @search request
    func fetchStorefrontID(_ completion: @escaping (Result<Storefront, Error>) -> Void) {
        
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
    
}
