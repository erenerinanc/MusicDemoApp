//
//  SearchResultsInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsBusinessLogic: AnyObject {
    func fetchPlaylists()
    func fetchFavorites()
}

protocol SearchResultsDataStore: AnyObject {
    
}

final class SearchResultsInteractor: SearchResultsBusinessLogic, SearchResultsDataStore {
    
    var presenter: SearchResultsPresentationLogic?
    var worker: SearchResultsWorkingLogic = SearchResultsWorker()
    
    func fetchPlaylists() {
        
    }
    
    func fetchFavorites() {
        
    }
    
}
