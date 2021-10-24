//
//  PlaylistRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistRoutingLogic: AnyObject {
    func routeToMediaPlayer()
}

protocol PlaylistDataPassing: AnyObject {
    var dataStore: PlaylistDataStore? { get }
}

final class PlaylistRouter: PlaylistRoutingLogic, PlaylistDataPassing {
    
    weak var viewController: PlaylistViewController?
    var dataStore: PlaylistDataStore?
    
    func routeToMediaPlayer() {
        let destVC = MediaPlayerViewController()
        self.viewController?.navigationController?.present(destVC, animated: true)
    }

}
