//
//  MediaPlayerPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerPresentationLogic: AnyObject {
    func presentSongDetails(response: MediaPlayer.Fetch.Response)
}

final class MediaPlayerPresenter: MediaPlayerPresentationLogic {
    
    weak var viewController: MediaPlayerDisplayLogic?
    
    func presentSongDetails(response: MediaPlayer.Fetch.Response) {
        let songs = response.songs.compactMap { MediaPlayer.Fetch.ViewModel.Song(label: $0.attributes?.name ?? "",
                                                                                      artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                      duration: $0.attributes?.durationInMillis ?? 0,
                                                                                             id: $0.id ?? "")
        }
        
        viewController?.displaySongDetail(viewModel: MediaPlayer.Fetch.ViewModel(songs: songs))
        
    }
}

