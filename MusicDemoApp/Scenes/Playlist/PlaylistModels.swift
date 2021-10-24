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
        }
        
        struct ViewModel {
            var catalogPlaylist: [Playlist.Fetch.ViewModel.CatalogPlaylist]
            var songData: [SongData]
            
            struct CatalogPlaylist {
                var artworkURL: String
                var name: String
                var description: String
                var songs: [Song]
                
                struct Song {
                    var songName: String
                    var artistName: String
                    var songArtworkURL: String
                    var id: String
                }
            }
          
        }
        
    }
    
}
// swiftlint:enable nesting
