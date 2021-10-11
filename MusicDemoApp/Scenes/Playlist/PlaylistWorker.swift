//
//  PlaylistWorker.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistWorkingLogic: AnyObject {
    func getCatalogPlaylists(request: Playlist.Fetch.Request,_ completion: @escaping (Result<CatalogPlaylist,Error>) -> Void)
    func play()
}

final class PlaylistWorker: PlaylistWorkingLogic {
    let musicAPI: AppleMusicAPI
    
    init(musicAPI: AppleMusicAPI) {
        self.musicAPI = musicAPI
    }
    
    func getCatalogPlaylists(request: Playlist.Fetch.Request, _ completion: @escaping (Result<CatalogPlaylist, Error>) -> Void) {
        musicAPI.fetch(request: APIRequest.getCatalogPlaylists(storeFrontID: request.storeFrontID, globalID: request.globalID), model: CatalogPlaylist.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        
    }
    
    func play() {
        
    }
        
}
