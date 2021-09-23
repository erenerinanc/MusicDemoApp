//
//  PlaylistPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistPresentationLogic: AnyObject {
    
}

final class PlaylistPresenter: PlaylistPresentationLogic {
    
    weak var viewController: PlaylistDisplayLogic?
    
}
