//
//  MediaPlayerInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerBusinessLogic: AnyObject {
    func playNextSong()
    func playPreviousSong()
    func pause()
    func play()
    func shuffleSongs()
    func fetchPlaybackState()
    func fetchSongDetails()
}

protocol MediaPlayerDataStore: AnyObject {
}

protocol MediaPlayerMusicPlayer: AnyObject {
    func play()
    func pause()
    func playNextSong()
    func playPreviousSong()
    func playSong(at songIndex: Int)
    func shuffle()
    var songs: [SongData] { get set }
    var playbackState: SystemMusicPlayer.PlaybackState? { get }
    var playingSongInformation: SystemMusicPlayer.PlayingSongInformation? { get }
    
    var playerStateDidChange: Notification.Name { get }
}

extension SystemMusicPlayer: MediaPlayerMusicPlayer {
    var playerStateDidChange: Notification.Name { SystemMusicPlayer.playerStateDidChange }
}

final class MediaPlayerInteractor: MediaPlayerBusinessLogic, MediaPlayerDataStore {
    
    var presenter: MediaPlayerPresentationLogic?
    var musicPlayer: MediaPlayerMusicPlayer
    
    init(musicPlayer: MediaPlayerMusicPlayer) {
        self.musicPlayer = musicPlayer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerStateDidChange(_:)),
                                               name: musicPlayer.playerStateDidChange,
                                               object: musicPlayer)
    }
    
    @objc private func playerStateDidChange(_ notification: Notification) {
        fetchSongDetails()
        fetchPlaybackState()
    }
    
    func playNextSong() {
        musicPlayer.playNextSong()
    }
    
    func playPreviousSong() {
        musicPlayer.playPreviousSong()
    }
    
    func fetchPlaybackState() {
        guard let playbackState = musicPlayer.playbackState else { return }
        presenter?.presentPlaybackState(playbackState: playbackState)
    }
    
    func fetchSongDetails() {
        guard let songInfo = musicPlayer.playingSongInformation else { return }
        presenter?.presentSongDetails(songInfo: songInfo)
    }

    func play() {
        guard musicPlayer.playbackState?.status != .playing else { return }
        musicPlayer.play()
    }
    
    func shuffleSongs() {
        musicPlayer.shuffle()
    }
    func pause() {
        guard musicPlayer.playbackState?.status != .paused else { return }
        musicPlayer.pause()
    }
}

