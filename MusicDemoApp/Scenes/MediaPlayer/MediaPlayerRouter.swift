//
//  MediaPlayerRouter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerRoutingLogic: AnyObject {
    
}

protocol MediaPlayerDataPassing: AnyObject {
    var dataStore: MediaPlayerDataStore? { get }
}

final class MediaPlayerRouter: MediaPlayerRoutingLogic, MediaPlayerDataPassing {
    
    weak var viewController: MediaPlayerViewController?
    var dataStore: MediaPlayerDataStore?
    
}
