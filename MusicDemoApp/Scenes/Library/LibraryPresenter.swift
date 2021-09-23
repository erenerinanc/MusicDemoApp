//
//  LibraryPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryPresentationLogic: AnyObject {
    
}

final class LibraryPresenter: LibraryPresentationLogic {
    
    weak var viewController: LibraryDisplayLogic?
    
}
