//
//  PlaylistInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistBusinessLogic: AnyObject {
    func fetchCatalogPlaylist()
}

protocol PlaylistDataStore: AnyObject {
    var playlistData: [CatalogPlaylistData]? { get }
    var storefrontID: String? { get set }
    var globalID: String? { get set }
}

protocol PlaylistMusicPlayer: AnyObject {
    func play()
    func pause()
    func playSong(at index: Int)
    func playNextSong()
    
    var songs: [SongData] { get set }
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    var playbackState: SystemMusicPlayer.PlaybackState? { get }
    var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: PlaylistMusicPlayer { }

final class PlaylistInteractor: PlaylistBusinessLogic, PlaylistDataStore {
    var mediaPlayerInteractor: MediaPlayerInteractor?
    
    init(worker: PlaylistWorkingLogic) {
        self.worker = worker
    }
    
    var presenter: PlaylistPresentationLogic?
    var worker: PlaylistWorkingLogic?
    
    var playlistData: [CatalogPlaylistData]?
    
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
                self.presenter?.presentCatalogPlaylist(response: Playlist.Fetch.Response(catalogPlaylistData: playlistData))
           
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}
