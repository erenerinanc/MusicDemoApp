//
//  SearchResultsPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import Foundation

protocol SearchResultsPresentationLogic: AnyObject {
    
}

final class SearchResultsPresenter: SearchResultsPresentationLogic {
    
    weak var viewController: SearchResultsDisplayLogic?
    
}
