//
//  PlaylistWorker.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistWorkingLogic: AnyObject {
    func getCatalogPlaylists(request: Playlist.Fetch.Request,_ completion: @escaping (Result<CatalogPlaylist,Error>) -> Void)
}

final class PlaylistWorker: PlaylistWorkingLogic {
    let musicAPI: AppleMusicAPI
    
    init(musicAPI: AppleMusicAPI) {
        self.musicAPI = musicAPI
    }
    
    func getCatalogPlaylists(request: Playlist.Fetch.Request, _ completion: @escaping (Result<CatalogPlaylist, Error>) -> Void) {
        musicAPI.getCatalogPlaylist(storeFrontId: request.storeFrontID, globalId: request.globalID) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
        
}
