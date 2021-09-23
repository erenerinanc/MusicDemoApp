//
//  LibraryInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryBusinessLogic: AnyObject {
    
}

protocol LibraryDataStore: AnyObject {
    
}

final class LibraryInteractor: LibraryBusinessLogic, LibraryDataStore {
    
    var presenter: LibraryPresentationLogic?
    var worker: LibraryWorkingLogic = LibraryWorker()
    
}
