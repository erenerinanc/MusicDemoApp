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
        let songs = response.songs.compactMap {  SearchResults.Fetch.SongViewModel.Song(id: $0.id ?? "",
                                                                                    name: $0.attributes?.name ?? "",
                                                                                    artistName: $0.attributes?.artistName ?? "",
                                                                                    artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                    duration: $0.attributes?.durationInMillis ?? 0,
                                                                                    albumName: $0.attributes?.albumName ?? "")
        }
        viewController?.displaySearchResults(for: SearchResults.Fetch.SongViewModel(songs: songs))
    }
    
    func presentSearchedArtists(response: SearchResults.Fetch.ArtistResponse) {
        let artists = response.artists.compactMap { SearchResults.Fetch.ArtistViewModel.Artist(id: $0.id ?? "",
                                                                                         name: $0.attributes?.name ?? "",
                                                                                         url: $0.attributes?.url ?? "",
                                                                                         genreName: $0.attributes?.genreNames?[0] ?? "")
        }
        viewController?.displaySearchResults(for: SearchResults.Fetch.ArtistViewModel(artists: artists))
    }
    
    
}
