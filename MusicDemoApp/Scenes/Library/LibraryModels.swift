//
//  LibraryModels.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

// swiftlint:disable nesting
enum Library {
    
    enum Fetch {
        
        struct Request {
            var globalID: String
        }
        
        struct PlaylistResponse {
            var playlists: [PlaylistData]
        }
        
        struct PlaylistSongsResponse {
            var catalogPlaylistData: [CatalogPlaylistData]
        }
        
        struct TopSongsResponse {
            var topSongs: [SongData]
        }
        
        struct PlaylistViewModel {
            var playlists: [Library.Fetch.PlaylistViewModel.Playlist]
        
            struct Playlist {
                var artworkURL: String
                var playlistName: String
                var globalID: String
            }

        }
        
        struct TopSongsViewModel {
            var topSongs: [Library.Fetch.TopSongsViewModel.TopSongs]
            
            struct TopSongs {
                var artistName: String
                var songName: String
                var artworkURL: String
                var id: String
            }
        }
        
    }
    
}
// swiftlint:enable nesting
