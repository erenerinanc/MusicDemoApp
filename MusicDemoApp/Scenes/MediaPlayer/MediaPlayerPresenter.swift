//
//  MediaPlayerPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerPresentationLogic: AnyObject {
    func presentPlaylistSongDetails(response: MediaPlayer.Fetch.PlaylistResponse)
    func presentTopSongDetails(response: MediaPlayer.Fetch.TopSongResponse)
}

final class MediaPlayerPresenter: MediaPlayerPresentationLogic {
    
    weak var viewController: MediaPlayerDisplayLogic?
    
    func presentPlaylistSongDetails(response: MediaPlayer.Fetch.PlaylistResponse) {
        let playlist = response.catalogSongData.compactMap { MediaPlayer.Fetch.PlaylistViewModel.PlaylistSong(label: $0.attributes?.name ?? "",
                                                                                                              artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                                              duration: $0.attributes?.durationInMillis ?? 0)
            
        }
        viewController?.displayPlaylistSongDetail(viewModel: MediaPlayer.Fetch.PlaylistViewModel(playlistData: playlist))
        
       
    }
    
    func presentTopSongDetails(response: MediaPlayer.Fetch.TopSongResponse) {
        let song = response.songData.compactMap { MediaPlayer.Fetch.TopSongViewModel.TopSong(label: $0.attributes?.name ?? "",
                                                                                      artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                      duration: $0.attributes?.durationInMillis ?? 0)
        }
        
        viewController?.displayTopSongDetail(viewModel: MediaPlayer.Fetch.TopSongViewModel(topSongData: song))
        
    }
}
