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
}

protocol LibraryDataStore: AnyObject {
    var playlists: [PlaylistData]? { get }
    var topSongs: [SongData]? { get }
}

protocol LibraryMusicPlayer: AnyObject {
    func play()
    func pause()
    func playSong(at index: Int)
    func playNextSong()
    
    var songs: [SongData] { get set }
    var playbackState: SystemMusicPlayer.PlaybackState? { get }
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: LibraryMusicPlayer { }

final class LibraryInteractor: LibraryBusinessLogic, LibraryDataStore {
    init(worker: LibraryWorkingLogic) {
        self.worker = worker
    }
    
    var presenter: LibraryPresentationLogic?
    let worker: LibraryWorkingLogic

    var playlists: [PlaylistData]?
    var topSongs: [SongData]?

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
