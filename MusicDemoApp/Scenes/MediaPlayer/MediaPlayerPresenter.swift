//
//  MediaPlayerPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerPresentationLogic: AnyObject {
    func presentSongDetails(response: MediaPlayer.Fetch.Response)
    func presentPlaybackState(viewModel: MediaPlayer.Fetch.PlaybackViewModel)
}

extension SongArtwork {
    func makeResizedURL(width: Int, height: Int) -> URL? {
        guard let url = self.url else { return nil }
        
        let resizedString = url
            .replacingOccurrences(of: "{w}", with: String(width))
            .replacingOccurrences(of: "{h}", with: String(height))
        
        return URL(string: resizedString)
    }
}

final class MediaPlayerPresenter: MediaPlayerPresentationLogic {
    
    weak var viewController: MediaPlayerDisplayLogic?
        
    func presentSongDetails(response: MediaPlayer.Fetch.Response) {
        let song = response.song
        let artworkURL = song.attributes?.artwork?.makeResizedURL(width: 1000, height: 1000)
        
        let model = MediaPlayer.Fetch.ViewModel(artworkURL: artworkURL,
                                                songName: song.attributes?.name ?? "Unnamed Song",
                                                artistName: song.attributes?.artistName ?? "Unknown Artist")
        
        viewController?.displaySongDetail(viewModel: model)
    }
    
    func presentPlaybackState(viewModel: MediaPlayer.Fetch.PlaybackViewModel) {
        viewController?.displayPlaybackState(viewModel: viewModel)
    }
}

