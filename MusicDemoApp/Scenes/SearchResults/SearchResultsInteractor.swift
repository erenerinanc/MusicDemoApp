//
//  SearchResultsInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsBusinessLogic: AnyObject {
    func fetchSearchResults(request: SearchResults.Fetch.Request)
    func playSong(at index: Int)
    func fetchNowPlayingSong()
}

protocol SearchResultsDataStore: AnyObject {
    var searchedSongs: [SongData]? {get}
    var searchedArtist: [ArtistsData]? {get}
}

protocol SearchResultsMusicPlayer: AnyObject {
    func playSong(at index: Int)
    var songs: [SongData] { get set }
    var playbackState: SystemMusicPlayer.PlaybackState? { get }
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: SearchResultsMusicPlayer { }

final class SearchResultsInteractor: SearchResultsBusinessLogic, SearchResultsDataStore {
    
    init(worker: SearchResultsWorkingLogic, musicPlayer: SearchResultsMusicPlayer) {
        self.worker = worker
        self.musicPlayer = musicPlayer
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerStateDidChange(_:)),
                                               name: musicPlayer.playerStateDidChange,
                                               object: musicPlayer)
    }
    
    let worker: SearchResultsWorkingLogic
    var presenter: SearchResultsPresentationLogic?
    let musicPlayer: SearchResultsMusicPlayer
    
    var searchedSongs: [SongData]?
    var searchedArtist: [ArtistsData]?
    
    
    func fetchSearchResults(request: SearchResults.Fetch.Request) {
        worker.getSearchResults(request: request) { result in
            switch result {
            case .success(let response):
                guard let searchedSongs = response.results?.songs?.data else { return }
                guard let searchedArtists = response.results?.artists?.data else { return }
                
                self.searchedSongs = searchedSongs
                self.searchedArtist = searchedArtists
                
                DispatchQueue.main.async {
                    self.presenter?.presentSearchedSongs(response: SearchResults.Fetch.SongResponse(songs: searchedSongs))
                    self.presenter?.presentSearchedArtists(response: SearchResults.Fetch.ArtistResponse(artists: searchedArtists))
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func playerStateDidChange(_ notification: Notification) {
        fetchNowPlayingSong()
    }
    
    func fetchNowPlayingSong() {
        guard let songInfo = musicPlayer.playingSongInformation else { return }
        guard let playbackState = musicPlayer.playbackState else { return }
        presenter?.presentNowPlayingSong(playbackState: playbackState, songInfo: songInfo)
    }
    
    func playSong(at index: Int) {
        guard let songs = searchedSongs else { return }
        musicPlayer.songs = songs
        musicPlayer.playSong(at: index)
    }

    
}
