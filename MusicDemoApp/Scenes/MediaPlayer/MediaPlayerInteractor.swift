//
//  MediaPlayerInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerBusinessLogic: AnyObject {
    func playInitialSong()
    func playNextSong()
    func playPreviousSong()
    func pause()
    func play()
    func fetchPlaybackState()
}

protocol MediaPlayerDataStore: AnyObject {
    var songData: [SongData]? { get set }
    var initialSongIndex: Int? { get set }
}

final class MediaPlayerInteractor: MediaPlayerBusinessLogic, MediaPlayerDataStore {
    
    var presenter: MediaPlayerPresentationLogic?
    var worker: MediaPlayerWorkingLogic = MediaPlayerWorker()
    
    var songData: [SongData]?
    var initialSongIndex: Int?
    
    private var playingSongIndex: Int = -1
    
    init() {
        worker.delegate = self
    }
    
    func playInitialSong() {
        guard let songData = songData else { return }
        playingSongIndex = initialSongIndex ?? 0
        worker.playSong(at: playingSongIndex, from: songData)
    }

    func playNextSong() {
        guard let songData = songData, songData.indices.contains(playingSongIndex + 1) else { return }
        worker.playNextSong()
    }
    
    func playPreviousSong() {
        guard let songData = songData, songData.indices.contains(playingSongIndex - 1) else { return }
        worker.playPreviousSong()
    }
    
    func fetchPlaybackState() {
        let playbackState = worker.playbackState
        presenter?.presentPlaybackState(viewModel: playbackState)
    }

    func play() {
        guard worker.playbackState.status != .playing else { return }
        worker.play()
    }
    
    func pause() {
        guard worker.playbackState.status != .paused else { return }
        worker.pause()
    }
}

extension MediaPlayerInteractor: MediaPlayerWorkerDelegate {
    func mediaPlayerWorkerCurrentPlayingItemDidChange(_ songID: String?) {
        guard
            let songData = songData,
            let song = songData.first(where: { $0.id == songID })
        else { return }
        
        presenter?.presentSongDetails(response: MediaPlayer.Fetch.Response(song: song))
    }
    
    func mediaPlayerWorkerPlaybackStateDidChange(_ state: MediaPlayer.Fetch.PlaybackViewModel, songID: String?) {
        presenter?.presentPlaybackState(viewModel: state)
    }
}
