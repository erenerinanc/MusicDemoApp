//
//  PlaylistRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistRoutingLogic: AnyObject {
    func routeToSongs(index: Int)
}

protocol PlaylistDataPassing: AnyObject {
    var dataStore: PlaylistDataStore? { get }
}

final class PlaylistRouter: PlaylistRoutingLogic, PlaylistDataPassing {
    
    weak var viewController: PlaylistViewController?
    var dataStore: PlaylistDataStore?
    
    func routeToSongs(index: Int) {
        let destVC = MediaPlayerViewController(index: index)
        destVC.router?.dataStore?.playlistData = dataStore?.playlistData?[0].relationships?.tracks?.data
        destVC.interactor?.getPlaylistSongs()
        destVC.isDisplayingPlaylistSongs = true
        self.viewController?.navigationController?.present(destVC, animated: true)
    }
}
