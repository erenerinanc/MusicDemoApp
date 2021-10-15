//
//  LibraryInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryBusinessLogic: AnyObject {
    func fetchPlaylists()
    func fetchTopCharts()
    func playSong(at index: Int) -> Bool
    func pause()
}

protocol LibraryDataStore: AnyObject {
    var playlists: [PlaylistData]? { get }
    var topSongs: [SongData]? { get }
}

protocol LibraryMusicPlayer: AnyObject {
    func play()
    func pause()
    func playSong(at index: Int)
    
    var songs: [SongData] { get set }
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    static var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: LibraryMusicPlayer { }

final class LibraryInteractor: LibraryBusinessLogic, LibraryDataStore {
    init(worker: LibraryWorkingLogic, musicPlayer: LibraryMusicPlayer) {
        self.worker = worker
        self.musicPlayer = musicPlayer
    }
    
    var presenter: LibraryPresentationLogic?
    let worker: LibraryWorkingLogic
    let musicPlayer: LibraryMusicPlayer
   
    var playlists: [PlaylistData]?
    var topSongs: [SongData]?
    
    func playSong(at index: Int) -> Bool {
        guard let songs = topSongs else { return false }
        musicPlayer.songs = songs
        musicPlayer.playSong(at: index)
        return true
    }
    
    func pause() {
        musicPlayer.pause()
    }

    func fetchPlaylists() {
        print("Gonna fetch playlists...")
        worker.fetchPlaylists { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response.data else { return }
                self?.playlists = data
                self?.presenter?.presentPlaylists(response: Library.Fetch.PlaylistResponse(playlists: data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTopCharts() {
        print("Gonna fetch top charts...")
        worker.fetchTopCharts { [weak self] result in
            switch result {
            case .success(let response):
                guard let songs = response.results?.songs else { return }
                guard let songData = songs[0].data else { return }
                self?.topSongs = songData
                self?.presenter?.presentTopSongs(response: Library.Fetch.TopSongsResponse(topSongs: songData))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
