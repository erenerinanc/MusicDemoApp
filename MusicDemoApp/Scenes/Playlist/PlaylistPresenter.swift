//
//  PlaylistPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistPresentationLogic: AnyObject {
    func presentCatalogPlaylist(response: Playlist.Fetch.Response)
    func presentNowplayingSong(playbackState: SystemMusicPlayer.PlaybackState, songInfo: SystemMusicPlayer.PlayingSongInformation) 
}

final class PlaylistPresenter: PlaylistPresentationLogic {
    
    weak var viewController: PlaylistDisplayLogic?
    
    func presentCatalogPlaylist(response: Playlist.Fetch.Response) {
        guard let songData = response.catalogPlaylistData[0].relationships?.tracks?.data else { return }
        
        
        let songs = songData.compactMap { Playlist.Fetch.ViewModel.CatalogPlaylist.Song(songName: $0.attributes?.name ?? "",
                                                                                        artistName: $0.attributes?.artistName ?? "",
                                                                                        songArtworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                        id: $0.id ?? ""
                                                                                        )
        }
        var totalSongDuration: Int = 0
        songData.compactMap {totalSongDuration += Int($0.attributes?.durationInMillis ?? 0)}
        let catalogPlaylist = response.catalogPlaylistData.compactMap { Playlist.Fetch.ViewModel.CatalogPlaylist(artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                                                 name: $0.attributes?.name ?? "",
                                                                                                                 description: "\(songs.count) Songs \(totalSongDuration / 3600000) Hours",
                                                                                                                 songs: songs
        )
        }
        
        DispatchQueue.main.async {
            self.viewController?.displayPlaylistDetails(for: Playlist.Fetch.ViewModel(catalogPlaylist: catalogPlaylist))
        }
        
    }
    
    func presentNowplayingSong(playbackState: SystemMusicPlayer.PlaybackState, songInfo: SystemMusicPlayer.PlayingSongInformation) {
        viewController?.displayNowPlayingSong(songInfo, isPlaying: playbackState.status == .playing)
    }
    
}
