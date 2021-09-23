//
//  PlaylistInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistBusinessLogic: AnyObject {
    
}

protocol PlaylistDataStore: AnyObject {
    
}

final class PlaylistInteractor: PlaylistBusinessLogic, PlaylistDataStore {
    
    var presenter: PlaylistPresentationLogic?
    var worker: PlaylistWorkingLogic = PlaylistWorker()
    
}
