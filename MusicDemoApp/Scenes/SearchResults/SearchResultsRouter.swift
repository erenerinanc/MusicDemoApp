//
//  SearchResultsRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsRoutingLogic: AnyObject {
    func routeToArtistDetail(with url: String)
}

protocol SearchResultsDataPassing: AnyObject {
    var dataStore: SearchResultsDataStore? { get }
}

final class SearchResultsRouter: SearchResultsRoutingLogic, SearchResultsDataPassing {
    
    weak var viewController: SearchResultsViewController?
    var dataStore: SearchResultsDataStore?
    
    func routeToArtistDetail(with url: String) {
        let destVC = ArtistDetailsViewController(url: url)
        viewController?.present(destVC, animated: true, completion: nil)
    }
}
