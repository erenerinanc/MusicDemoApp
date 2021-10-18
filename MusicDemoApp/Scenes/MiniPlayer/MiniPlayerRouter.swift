//
//  MiniPlayerRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 18.10.2021.
//

import Foundation

protocol MiniPlayerRoutingLogic: AnyObject {
    func routeToMediaPlayer()
}

protocol MiniPlayerDataPassing: AnyObject {
    var dataStore: MiniPlayerDataStore? { get }
}

final class MiniPlayerRouter: MiniPlayerRoutingLogic, MiniPlayerDataPassing {
    
    weak var viewController: MiniPlayerViewController?
    var dataStore: MiniPlayerDataStore?
    let musicPlayer: SystemMusicPlayer
    
    init(musicPlayer: SystemMusicPlayer) {
        self.musicPlayer = musicPlayer
    }
    
    func routeToMediaPlayer() {
        let destVC = MediaPlayerViewController(musicPlayer: musicPlayer)
        viewController?.present(destVC, animated: true)
    }
    
}
