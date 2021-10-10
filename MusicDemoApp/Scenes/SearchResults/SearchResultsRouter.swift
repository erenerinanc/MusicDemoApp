//
//  SearchResultsRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsRoutingLogic: AnyObject {
    func routeToSong(index: Int)
}

protocol SearchResultsDataPassing: AnyObject {
    var dataStore: SearchResultsDataStore? { get }
}

final class SearchResultsRouter: SearchResultsRoutingLogic, SearchResultsDataPassing {
    
    weak var viewController: SearchResultsViewController?
    var dataStore: SearchResultsDataStore?
    
    func routeToSong(index: Int) {
        let destVC = MediaPlayerViewController(index: index)
        destVC.router?.dataStore?.songData = dataStore?.searchedSongs
        destVC.isDisplayingPlaylistSongs = false
        destVC.interactor?.getSongs()
        self.viewController?.navigationController?.present(destVC, animated: true)
    }
}
