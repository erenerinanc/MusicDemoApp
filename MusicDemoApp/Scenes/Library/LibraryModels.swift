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
            
        }
        
        struct ViewModel {
            var favoriteSongs: [Library.Fetch.ViewModel.Song]
            
            struct Song {
                var id: String
                var name: String
                var artistName: String
                var artworkURL: String
            }
            
        }
        
    }
    
}
// swiftlint:enable nesting
