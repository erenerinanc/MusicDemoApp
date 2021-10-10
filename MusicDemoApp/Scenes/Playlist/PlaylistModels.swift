//
//  PlaylistModels.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

// swiftlint:disable nesting
enum Playlist {
    
    enum Fetch {
        
        struct Request {
            var storeFrontID: String
            var globalID: String
        }
        
        struct Response {
            var catalogPlaylistData: [CatalogPlaylistData]
            var catalogSongData: [SongData]
        }
        
        struct ViewModel {
            var catalogPlaylist: [Playlist.Fetch.ViewModel.CatalogPlaylist]
            var songs: [Playlist.Fetch.ViewModel.Song]
            
            struct CatalogPlaylist {
                var artworkURL: String
                var name: String
                var description: String
            }
            
            struct Song {
                var songURL: String
                var name: String
                var description: String
                var artworkURL: String
                var id: String
            }
        }
        
    }
    
}
// swiftlint:enable nesting
