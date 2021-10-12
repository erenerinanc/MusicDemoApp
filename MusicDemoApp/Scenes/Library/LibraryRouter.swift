//
//  LibraryRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryRoutingLogic: AnyObject {
    func routeToCatalogPlaylist(globalID: String)
    func routeToSong(index: Int)
}

protocol LibraryDataPassing: AnyObject {
    var dataStore: LibraryDataStore? { get }
}

final class LibraryRouter: LibraryRoutingLogic, LibraryDataPassing {
    
    weak var viewController: LibraryViewController?
    var dataStore: LibraryDataStore?
    var musicAPI: AppleMusicAPI
    var storeFrontID: String
    
    init(storeFrontID: String, musicAPI: AppleMusicAPI) {
        self.musicAPI = musicAPI
        self.storeFrontID = storeFrontID
    }
    
    func routeToCatalogPlaylist(globalID: String) {
        let destVC = PlaylistViewController(musicAPI: musicAPI)
        destVC.router?.dataStore?.storefrontID = storeFrontID
        destVC.router?.dataStore?.globalID = globalID
        viewController?.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func routeToSong(index: Int) {
        let destVC = MediaPlayerViewController()
        destVC.router?.dataStore?.songData = dataStore?.topSongs
        destVC.router?.dataStore?.initialSongIndex = index
        viewController?.navigationController?.present(destVC, animated: true)
    }

    
}
