//
//  MiniPlayerPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 18.10.2021.
//

import Foundation

protocol MiniPlayerPresentationLogic: AnyObject {
    func presentPlaybackState(playbackState: SystemMusicPlayer.PlaybackState)
    func presentSongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation)
}

final class MiniPlayerPresenter: MiniPlayerPresentationLogic {
    
    weak var viewController: MiniPlayerDisplayLogic?
    
    func presentPlaybackState(playbackState: SystemMusicPlayer.PlaybackState) {
        viewController?.displayPlaybackState(playbackState: playbackState)
    }
    
    func presentSongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation) {
        viewController?.displaySongDetail(songInfo: songInfo)
    }
}
