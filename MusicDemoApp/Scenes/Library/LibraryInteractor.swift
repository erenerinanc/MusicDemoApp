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
    func fetchNowPlayingSong()
    
    func playSong(at index: Int)
    func play()
    func pause()
    func playNextSong()
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
    init(worker: LibraryWorkingLogic, musicPlayer: LibraryMusicPlayer) {
        self.worker = worker
        self.musicPlayer = musicPlayer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerStateDidChange(_:)),
                                               name: musicPlayer.playerStateDidChange,
                                               object: musicPlayer)
    }
    
    var presenter: LibraryPresentationLogic?
    let worker: LibraryWorkingLogic
    let musicPlayer: LibraryMusicPlayer
   
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
    
    func playSong(at index: Int) {
        guard let songs = topSongs else { return }
        musicPlayer.songs = songs
        musicPlayer.playSong(at: index)
    }
    
    func play() {
        musicPlayer.play()
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func playNextSong() {
        musicPlayer.playNextSong()
    }
    
    @objc func playerStateDidChange(_ notification: Notification) {
        fetchNowPlayingSong()
    }
    
    func fetchNowPlayingSong() {
        guard let playbackState = musicPlayer.playbackState else { return }
        guard let songInfo = musicPlayer.playingSongInformation else { return }
        presenter?.presentNowPlayingSong(playbackState: playbackState, songInfo: songInfo)
    }

}
