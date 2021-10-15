//
//  PlaylistInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistBusinessLogic: AnyObject {
    func fetchCatalogPlaylist()
    func playSong(at index: Int) -> Bool
    func playFirstSong()
    func pause()
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
    
    var songs: [SongData] { get set }
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: PlaylistMusicPlayer { }

final class PlaylistInteractor: PlaylistBusinessLogic, PlaylistDataStore {
    var mediaPlayerInteractor: MediaPlayerInteractor?
    
    init(worker: PlaylistWorkingLogic, musicPlayer: PlaylistMusicPlayer) {
        self.worker = worker
        self.musicPlayer = musicPlayer
    }
    
    var presenter: PlaylistPresentationLogic?
    let musicPlayer: PlaylistMusicPlayer
    var worker: PlaylistWorkingLogic?
    
    var playlistData: [CatalogPlaylistData]?
    
    var storefrontID: String?
    var globalID: String?
    
    func playFirstSong() {
        guard
            let playlistData = playlistData,
            let songs = playlistData[0].relationships?.tracks?.data
        else {
            return
        }
        
        musicPlayer.songs = songs
        musicPlayer.playSong(at: 0)
    }
    
    func playSong(at index: Int) -> Bool {
        guard
            let playlistData = playlistData,
            let songs = playlistData[0].relationships?.tracks?.data
        else {
            return false
        }
        
        musicPlayer.songs = songs
        musicPlayer.playSong(at: index)
        return true
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
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
