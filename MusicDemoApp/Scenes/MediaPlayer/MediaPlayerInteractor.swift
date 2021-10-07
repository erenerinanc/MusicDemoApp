//
//  MediaPlayerInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerBusinessLogic: AnyObject {
    func getPlaylistSongs()
    func getTopSongs()
}

protocol MediaPlayerDataStore: AnyObject {
    var playlistData: [CatalogSongData]? {get set}
    var songData: [SongData]? {get set}
    
}

final class MediaPlayerInteractor: MediaPlayerBusinessLogic, MediaPlayerDataStore {
    
    var presenter: MediaPlayerPresentationLogic?
    var worker: MediaPlayerWorkingLogic = MediaPlayerWorker()
    
    var playlistData: [CatalogSongData]?
    var songData: [SongData]?
    
    
    func getPlaylistSongs() {
        guard let playlistData = playlistData else { return }
        presenter?.presentPlaylistSongDetails(response: MediaPlayer.Fetch.PlaylistResponse(catalogSongData: playlistData))
    }
    
    func getTopSongs() {
        guard let songData = songData else { return }
        presenter?.presentTopSongDetails(response: MediaPlayer.Fetch.TopSongResponse(songData: songData))
    }
    
}
