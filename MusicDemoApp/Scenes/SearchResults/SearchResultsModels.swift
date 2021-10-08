//
//  SearchResultsModels.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

// swiftlint:disable nesting
enum SearchResults {
    
    enum Fetch {
        
        struct Request {
            var searchQuery: String
        }
        
        struct SongResponse {
            let songs: [SongData]
            
        }
        
        struct ArtistResponse {
            let artists: [ArtistsData]
        }
        
        struct SongViewModel {
            var songs: [SearchResults.Fetch.SongViewModel.Song]
            
            struct Song {
                var id: String
                var name: String
                var artistName: String
                var artworkURL: String
                var duration: Int
                var albumName: String
            }
        }
        
        struct ArtistViewModel {
            var artists: [SearchResults.Fetch.ArtistViewModel.Artist]
            
            
            struct Artist {
                var id: String
                var name: String
                var url: String
                var genreName: String
            }
        }
        
    }
    
}
// swiftlint:enable nesting
