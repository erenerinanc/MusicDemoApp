//
//  LibraryRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryRoutingLogic: AnyObject {
    
}

protocol LibraryDataPassing: class {
    var dataStore: LibraryDataStore? { get }
}

final class LibraryRouter: LibraryRoutingLogic, LibraryDataPassing {
    
    weak var viewController: LibraryViewController?
    var dataStore: LibraryDataStore?
    
}
