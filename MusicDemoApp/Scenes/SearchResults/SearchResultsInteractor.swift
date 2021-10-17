//
//  SearchResultsInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsBusinessLogic: AnyObject {
    func fetchSearchResults(request: SearchResults.Fetch.Request)
    func playSong(at index: Int) -> Bool
}

protocol SearchResultsDataStore: AnyObject {
    var searchedSongs: [SongData]? {get}
    var searchedArtist: [ArtistsData]? {get}
}

protocol SearchResultsMusicPlayer: AnyObject {
    func playSong(at index: Int)
    var songs: [SongData] { get set }
    
    //these will be used to fetch changes on the playing song and display on the cell and on mini media player
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    static var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: SearchResultsMusicPlayer { }

final class SearchResultsInteractor: SearchResultsBusinessLogic, SearchResultsDataStore {
    
    init(worker: SearchResultsWorkingLogic, musicPlayer: SearchResultsMusicPlayer) {
        self.worker = worker
        self.musicPlayer = musicPlayer
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
                
                self.presenter?.presentSearchedSongs(response: SearchResults.Fetch.SongResponse(songs: searchedSongs))
                self.presenter?.presentSearchedArtists(response: SearchResults.Fetch.ArtistResponse(artists: searchedArtists))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func playSong(at index: Int) -> Bool {
        guard let songs = searchedSongs else { return false }
        
        musicPlayer.songs = songs
        musicPlayer.playSong(at: index)
        return true
    }
    
}
