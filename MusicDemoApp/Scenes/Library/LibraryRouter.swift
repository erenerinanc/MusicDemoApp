//
//  LibraryRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryRoutingLogic: AnyObject {
    func routeToCatalogPlaylist(globalID: String)
    func routeToMediaPlayer()
}

protocol LibraryDataPassing: AnyObject {
    var dataStore: LibraryDataStore? { get }
}

final class LibraryRouter: LibraryRoutingLogic, LibraryDataPassing {
    
    weak var viewController: LibraryViewController?
    var dataStore: LibraryDataStore?
    var musicAPI: AppleMusicAPI
    var storeFrontID: String
    var musicPlayer: SystemMusicPlayer
    
    init(storeFrontID: String, musicAPI: AppleMusicAPI, musicPlayer: SystemMusicPlayer) {
        self.musicAPI = musicAPI
        self.storeFrontID = storeFrontID
        self.musicPlayer = musicPlayer
    }
    
    func routeToCatalogPlaylist(globalID: String) {
        let destVC = PlaylistViewController(musicAPI: musicAPI, musicPlayer: musicPlayer)
        destVC.router?.dataStore?.storefrontID = storeFrontID
        destVC.router?.dataStore?.globalID = globalID
        viewController?.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func routeToMediaPlayer() {
        let destVC = MediaPlayerViewController(musicPlayer: musicPlayer)
        viewController?.navigationController?.present(destVC, animated: true)
    }

    
}
