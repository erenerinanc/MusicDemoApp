//
//  MediaPlayerPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerPresentationLogic: AnyObject {
    func presentSongDetails(songInfo: SystemMusicPlayer.PlayingSongInformation)
    func presentPlaybackState(playbackState: SystemMusicPlayer.PlaybackState)
}

final class MediaPlayerPresenter: MediaPlayerPresentationLogic {
    
    weak var viewController: MediaPlayerDisplayLogic?
    
    func presentSongDetails(songInfo: SystemMusicPlayer.PlayingSongInformation) {
        viewController?.displaySongDetail(songInfo: songInfo)
    }
        
    func presentPlaybackState(playbackState: SystemMusicPlayer.PlaybackState) {
        viewController?.displayPlaybackState(playbackState: playbackState)
    }

}

