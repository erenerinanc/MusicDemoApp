//
//  PlaylistRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistRoutingLogic: AnyObject {
    func routeToMediaPlayer()
    func pauseSong()
}

protocol PlaylistDataPassing: AnyObject {
    var dataStore: PlaylistDataStore? { get }
}

final class PlaylistRouter: PlaylistRoutingLogic, PlaylistDataPassing {
    
    weak var viewController: PlaylistViewController?
    var dataStore: PlaylistDataStore?
    
    func routeToMediaPlayer() {
        guard let musicPlayer = viewController?.appMusicPlayer else { return }
        let destVC = MediaPlayerViewController(musicPlayer: musicPlayer)
        self.viewController?.navigationController?.present(destVC, animated: true)
    }
    
    func pauseSong() {
        guard let musicPlayer = viewController?.appMusicPlayer else { return }
        let destVC = MediaPlayerViewController(musicPlayer: musicPlayer)
        destVC.interactor?.pause()
    }
}
