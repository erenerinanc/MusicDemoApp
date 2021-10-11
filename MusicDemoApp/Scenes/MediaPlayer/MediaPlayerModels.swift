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
            var song: SongData
        }
        
        struct ViewModel {
            let artworkURL: URL?
            let songName: String
            let artistName: String
        }
        
        struct PlaybackViewModel {
            let status: PlaybackStatus
            let currentTime: TimeInterval
            let songDuration: TimeInterval
            
            enum PlaybackStatus {
                case playing, paused
            }
        }
        
    }
    
}
// swiftlint:enable nesting
