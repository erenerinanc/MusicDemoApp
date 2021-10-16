//
//  MusicInteractpr.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 14.10.2021.
//

import Foundation
import MediaPlayer


class SystemMusicPlayer {
    static let playerStateDidChange = Notification.Name("SystemMusicPlayer.playerStateDidChange")
    
    private var musicPlayer: MPMusicPlayerController & MPSystemMusicPlayerController {
        MPMusicPlayerController.systemMusicPlayer
    }
    
    var songs: [SongData] = [] {
        didSet { musicPlayer.setQueue(with: songs.compactMap(\.id)) }
    }
    
    private var playingSongID: String? {
        musicPlayer.nowPlayingItem?.playbackStoreID
    }
    
    private var playingSong: SongData? {
        guard
            let songID = playingSongID,
            let song = songs.first(where: { $0.id == songID })
        else {
            return nil
        }
        
        return song
    }
    
    var playbackState: PlaybackState? {
        guard playingSong != nil else { return nil }
        let mpState = musicPlayer.playbackState
        let isPaused = mpState == .interrupted || mpState == .paused || mpState == .stopped
        
        return PlaybackState(status: isPaused ? .paused : .playing,
                             currentTime: musicPlayer.currentPlaybackTime,
                             songDuration: musicPlayer.nowPlayingItem?.playbackDuration ?? 0)
    }
    
    var playingSongInformation: PlayingSongInformation? {
        guard let playingItem = musicPlayer.nowPlayingItem else { return nil }
        
        guard let artwork = playingSong?.attributes?.artwork else { return nil }
        guard let artworkURL = artwork.makeResizedURL(width: 1000, height: 1000) else { return nil }
        
        return PlayingSongInformation(artworkURL: artworkURL,
                                      songName: playingItem.title ?? "Unnamed Song",
                                      artistName: playingItem.artist ?? "Unknown Artist")
    }
    
    var currentIndexInSongsArray = 0
    
    //MARK: -Object Lifecycle
    
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
    
    @objc private func musicPlayerPlaybackStateDidChange(_ notification: Notification) {
        notifyChanges()
    }
    
    @objc private func musicPlayerNowPlayingItemDidChange(_ notification: Notification) {
        notifyChanges()
    }
    
    private func notifyChanges() {
        NotificationCenter.default.post(name: SystemMusicPlayer.playerStateDidChange, object: self)
    }
    
    func playSong(at songIndex: Int) {
        var songs = songs
        currentIndexInSongsArray = songIndex
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
        self.currentIndexInSongsArray += 1
        musicPlayer.skipToNextItem()
        musicPlayer.play()
    }
    
    func playPreviousSong() {
        if currentIndexInSongsArray <= 0 {
            currentIndexInSongsArray = 0
        } else {
            currentIndexInSongsArray -= 1
        }
       
        playSong(at: currentIndexInSongsArray)
    }
    
    func shuffle() {
        let songs = songs.shuffled()
        musicPlayer.setQueue(with: songs.compactMap(\.id))
        play()
    }
}

extension SystemMusicPlayer {
    struct PlaybackState: Equatable {
        let status: Status
        let currentTime: TimeInterval
        let songDuration: TimeInterval
        
        enum Status: Equatable {
            case playing, paused
        }
    }
}

extension SystemMusicPlayer {
    struct PlayingSongInformation: Equatable {
        let artworkURL: URL
        let songName: String
        let artistName: String
    }
}
