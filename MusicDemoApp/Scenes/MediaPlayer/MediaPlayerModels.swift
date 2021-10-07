//
//  MediaPlayerModels.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

// swiftlint:disable nesting
enum MediaPlayer {
    
    enum Fetch {
        
        struct Request {
            
        }
        
        struct PlaylistResponse {
            var catalogSongData: [CatalogSongData]
        }
        
        struct TopSongResponse {
            var songData: [SongData]
        }
        
        struct PlaylistViewModel {
            var playlistData: [MediaPlayer.Fetch.PlaylistViewModel.PlaylistSong]
            
            struct PlaylistSong {
                var label: String
                var artworkURL: String
                var duration: Int
            }
        }
        
        struct TopSongViewModel {
            var topSongData: [MediaPlayer.Fetch.TopSongViewModel.TopSong]
            
            struct TopSong {
                var label: String
                var artworkURL: String
                var duration: Int
            }
        }
        
    }
    
}
// swiftlint:enable nesting
