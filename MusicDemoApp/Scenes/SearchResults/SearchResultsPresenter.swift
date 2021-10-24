//
//  SearchResultsPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsPresentationLogic: AnyObject {
    func presentSearchedSongs(response: SearchResults.Fetch.SongResponse)
    func presentSearchedArtists(response: SearchResults.Fetch.ArtistResponse)
}

final class SearchResultsPresenter: SearchResultsPresentationLogic {
    
    weak var viewController: SearchResultsDisplayLogic?
    
    func presentSearchedSongs(response: SearchResults.Fetch.SongResponse) {
        let songs = response.songs.compactMap {  SearchResults.Fetch.SongViewModel.Song(name: $0.attributes?.name ?? "",
                                                                                        artistName: $0.attributes?.artistName ?? "",
                                                                                        artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                        id: $0.id ?? "")
        }
        viewController?.displaySearchResults(for: SearchResults.Fetch.SongViewModel(songs: songs, songData: response.songs))
    }
    
    func presentSearchedArtists(response: SearchResults.Fetch.ArtistResponse) {
        let artists = response.artists.compactMap { SearchResults.Fetch.ArtistViewModel.Artist(name: $0.attributes?.name ?? "",
                                                                                               url: $0.attributes?.url ?? "")
        }
        viewController?.displaySearchResults(for: SearchResults.Fetch.ArtistViewModel(artists: artists))
    }
    
}
