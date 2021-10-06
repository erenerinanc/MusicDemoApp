//
//  PlaylistInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistBusinessLogic: AnyObject {
    func fetchCatalogPlaylist(request: Playlist.Fetch.Request)
}

protocol PlaylistDataStore: AnyObject {
    
}

final class PlaylistInteractor: PlaylistBusinessLogic, PlaylistDataStore {
    
    init(musicAPI: AppleMusicAPI) {
        self.worker = PlaylistWorker(musicAPI: musicAPI)
    }
    
    var presenter: PlaylistPresentationLogic?
    var worker: PlaylistWorkingLogic?
    
    var playlistData: [CatalogPlaylistData] = []
    var catalogSongs: [CatalogSongData] = []
    
    func fetchCatalogPlaylist(request: Playlist.Fetch.Request) {
        worker?.getCatalogPlaylists(request: request, { result in
            switch result {
            case .success(let response):
                guard let playlistData = response.data else { return }
                self.playlistData = playlistData
             
                guard let catalogSongData = response.data?[0].relationships?.tracks?.data else { return }
                self.catalogSongs = catalogSongData
                
                self.presenter?.presentCatalogPlaylist(response: Playlist.Fetch.Response(catalogPlaylistData: playlistData, catalogSongData: catalogSongData))
           
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
