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
        
        struct Response {
            var playlists: [PlaylistData]
        }
        
        struct ViewModel {
            var playlists: [Library.Fetch.ViewModel.Playlist]
            
            struct Playlist {
                var artworkURL: String
                var playlistName: String
                var songCount: Int
            }
            
        }
        
    }
    
}
// swiftlint:enable nesting
