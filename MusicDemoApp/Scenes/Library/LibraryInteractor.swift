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
    func fetchPlaybackState()
    func fetchSongDetails()
    
    func playSong(at index: Int) -> Bool
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
    
    func playSong(at index: Int) -> Bool {
        guard let songs = topSongs else { return false }
        musicPlayer.songs = songs
        musicPlayer.playSong(at: index)
        return true
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
        fetchPlaybackState()
        fetchSongDetails()
    }
    
    func fetchPlaybackState() {
        guard let playbackState = musicPlayer.playbackState else { return }
        presenter?.presentPlaybackState(playbackState: playbackState)
    }
    
    func fetchSongDetails() {
        guard let songInfo = musicPlayer.playingSongInformation else { return }
        presenter?.presentSongDetail(songInfo: songInfo)
    }
}
