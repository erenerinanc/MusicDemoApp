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
            
        }
        
        struct PlaylistResponse {
            var playlists: [PlaylistData]
        }
        
        struct TopSongsResponse {
            var topSongs: [SongData]
        }
        
        struct PlaylistViewModel {
            var playlists: [Library.Fetch.PlaylistViewModel.Playlist]
        
            struct Playlist {
                var artworkURL: String
                var playlistName: String
                var songCount: Int
            }

        }
        
        struct TopSongsViewModel {
            var topSongs: [Library.Fetch.TopSongsViewModel.TopSongs]
            
            struct TopSongs {
                var artistName: String
                var songName: String
                var artworkURL: String
            }
        }
        
    }
    
}
// swiftlint:enable nesting
