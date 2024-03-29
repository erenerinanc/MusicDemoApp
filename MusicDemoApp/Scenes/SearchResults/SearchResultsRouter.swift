//
//  SearchResultsRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsRoutingLogic: AnyObject {
    func routeToMediaPlayer()
    func routeToArtistDetail(with url: String)
}

protocol SearchResultsDataPassing: AnyObject {
    var dataStore: SearchResultsDataStore? { get }
}

final class SearchResultsRouter: SearchResultsRoutingLogic, SearchResultsDataPassing {
    
    weak var viewController: SearchResultsViewController?
    var dataStore: SearchResultsDataStore?
    let musicPlayer: SystemMusicPlayer
    
    init(musicPlayer: SystemMusicPlayer) {
        self.musicPlayer = musicPlayer
    }
    
    func routeToMediaPlayer() {
        let destVC = MediaPlayerViewController(musicPlayer: musicPlayer)
        viewController?.present(destVC, animated: true, completion: nil)
    }
    
    func routeToArtistDetail(with url: String) {
        let destVC = ArtistDetailsViewController(url: url)
        viewController?.present(destVC, animated: true, completion: nil)
    }
}
