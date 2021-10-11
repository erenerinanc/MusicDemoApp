//
//  MediaPlayerWorker.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation
import MusicKit
import MediaPlayer

typealias SystemMusicPlayer = MPMusicPlayerController & MPSystemMusicPlayerController

protocol MediaPlayerWorkingLogic: AnyObject {
    var delegate: MediaPlayerWorkerDelegate? { get set }
    func playSong(at songIndex: Int, from songs: [SongData])
    func playNextSong()
    func playPreviousSong()
    
    func play()
    func pause()
    
    var playbackState: MediaPlayer.Fetch.PlaybackViewModel { get }
}

protocol MediaPlayerWorkerDelegate: AnyObject {
    func mediaPlayerWorkerPlaybackStateDidChange(_ state: MediaPlayer.Fetch.PlaybackViewModel, songID: String?)
    func mediaPlayerWorkerCurrentPlayingItemDidChange(_ songID: String?)
    // TODO: volume did change
}

final class MediaPlayerWorker: MediaPlayerWorkingLogic {
    private var musicPlayer: SystemMusicPlayer { MPMusicPlayerController.systemMusicPlayer }
    weak var delegate: MediaPlayerWorkerDelegate?
    
    init() {
        musicPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(musicPlayerPlaybackStateDidChange(_:)),
                                               name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                               object: musicPlayer)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(musicPlayerNowPlayingItemDidChange(_:)),
                                               name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: musicPlayer)
    }
    
    deinit {
        musicPlayer.endGeneratingPlaybackNotifications()
    }
    
    private var playingSongID: String? {
        musicPlayer.nowPlayingItem?.playbackStoreID
    }
    
    @objc private func musicPlayerPlaybackStateDidChange(_ notification: Notification) {
        delegate?.mediaPlayerWorkerPlaybackStateDidChange(playbackState, songID: playingSongID)
    }
    
    @objc private func musicPlayerNowPlayingItemDidChange(_ notification: Notification) {
        delegate?.mediaPlayerWorkerCurrentPlayingItemDidChange(playingSongID)
    }
    
    func playSong(at songIndex: Int, from songs: [SongData]) {
        var songs = songs
        songs.removeFirst(songIndex)

        musicPlayer.setQueue(with: songs.compactMap(\.id))
        musicPlayer.play()
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func play() {
        musicPlayer.play()
    }
    
    func playNextSong() {
        musicPlayer.skipToNextItem()
        musicPlayer.play()
    }
    
    func playPreviousSong() {
        musicPlayer.skipToPreviousItem()
        musicPlayer.play()
    }
    
    var playbackState: MediaPlayer.Fetch.PlaybackViewModel {
        let mpState = musicPlayer.playbackState
        let isPaused = mpState == .interrupted || mpState == .paused || mpState == .stopped
        
        return MediaPlayer.Fetch.PlaybackViewModel(status: isPaused ? .paused : .playing,
                                              currentTime: musicPlayer.currentPlaybackTime,
                                              songDuration: musicPlayer.nowPlayingItem?.playbackDuration ?? 0)
    }
}
