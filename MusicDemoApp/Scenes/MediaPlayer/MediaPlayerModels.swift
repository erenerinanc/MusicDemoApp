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
        
        struct Response {
            var songs: [SongData]
        }
        
        struct ViewModel {
            var songs: [MediaPlayer.Fetch.ViewModel.Song]
            
            struct Song {
                var label: String
                var artworkURL: String
                var duration: Int
                var id: String
            }
        }
        
    }
    
}
// swiftlint:enable nesting
