//
//  MiniPlayerInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 18.10.2021.
//

import Foundation

protocol MiniPlayerBusinessLogic: AnyObject {
    func fetchPlaybackState()
    func fetchSongDetail()
    func play()
    func pause()
    func playNextSong()
}

protocol MiniPlayerDataStore: AnyObject {
    
}

protocol MiniPlayerMusicPlayer {
    func play()
    func pause()
    func playNextSong()
    var playbackState: SystemMusicPlayer.PlaybackState? { get }
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: MiniPlayerMusicPlayer { }

final class MiniPlayerInteractor: MiniPlayerBusinessLogic, MiniPlayerDataStore {
    
    var presenter: MiniPlayerPresentationLogic?
    var worker: MiniPlayerWorkingLogic = MiniPlayerWorker()
    let musicPlayer: MiniPlayerMusicPlayer
    
    init(musicPlayer: SystemMusicPlayer) {
        self.musicPlayer = musicPlayer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerStateDidChange(_:)),
                                               name: musicPlayer.playerStateDidChange,
                                               object: musicPlayer)
    }
    
    @objc func playerStateDidChange(_ notification: Notification){
        fetchPlaybackState()
        fetchSongDetail()
    }
    
    func fetchPlaybackState() {
        guard let playbackState = musicPlayer.playbackState else { return }
        presenter?.presentPlaybackState(playbackState: playbackState)
    }
    
    func fetchSongDetail() {
        guard let songInfo = musicPlayer.playingSongInformation else { return }
        presenter?.presentSongDetail(songInfo: songInfo)
    }
    
    func play() {
        musicPlayer.play()
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func playNextSong() {
        musicPlayer.playNextSong()
    }
}
