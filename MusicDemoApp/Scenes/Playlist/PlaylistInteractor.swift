//
//  PlaylistInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistBusinessLogic: AnyObject {
    func fetchCatalogPlaylist()
    func play()
}

protocol PlaylistDataStore: AnyObject {
    var playlistData: [CatalogPlaylistData]? {get}
    var catalogSongs: [SongData]? {get}
    var storefrontID: String? {get set}
    var globalID: String? {get set}
}

final class PlaylistInteractor: PlaylistBusinessLogic, PlaylistDataStore {
    
    init(musicAPI: AppleMusicAPI) {
        self.worker = PlaylistWorker(musicAPI: musicAPI)
    }
    
    var presenter: PlaylistPresentationLogic?
    var worker: PlaylistWorkingLogic?
    
    var playlistData: [CatalogPlaylistData]?
    var catalogSongs: [SongData]?
    
    var storefrontID: String?
    var globalID: String?
    
    func fetchCatalogPlaylist() {
        guard let storefrontID = storefrontID else { return }
        guard let globalID = globalID else { return }
        worker?.getCatalogPlaylists(request: Playlist.Fetch.Request(storeFrontID: storefrontID, globalID: globalID), { result in
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
    
    func play() {
        worker?.play()
    }
}
