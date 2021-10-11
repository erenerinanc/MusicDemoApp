//
//  SearchResultsInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsBusinessLogic: AnyObject {
    func fetchSearchResults(request: SearchResults.Fetch.Request)
}

protocol SearchResultsDataStore: AnyObject {
    var searchedSongs: [SongData]? {get}
    var searchedArtist: [ArtistsData]? {get}
}

final class SearchResultsInteractor: SearchResultsBusinessLogic, SearchResultsDataStore {
    
    init(musicAPI: AppleMusicAPI, storeFrontID: String) {
        self.worker = SearchResultsWorker(musicAPI: musicAPI, storeFrontID: storeFrontID)
    }
    
    var presenter: SearchResultsPresentationLogic?
    var worker: SearchResultsWorkingLogic
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
    
}
