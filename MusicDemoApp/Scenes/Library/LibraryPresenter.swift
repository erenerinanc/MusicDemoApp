//
//  LibraryPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryPresentationLogic: AnyObject {
    func presentPlaylists(response: Library.Fetch.PlaylistResponse)
    func presentTopSongs(response: Library.Fetch.TopSongsResponse)
}

final class LibraryPresenter: LibraryPresentationLogic {

    weak var viewController: LibraryDisplayLogic?
    
    func presentPlaylists(response: Library.Fetch.PlaylistResponse) {
        let playlists = response.playlists.compactMap {  Library.Fetch.PlaylistViewModel.Playlist(artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                                  playlistName: $0.attributes?.name ?? "",
                                                                                                  globalID: $0.attributes?.playParams?.globalID ?? ""
                                                                                                  )
        }
        viewController?.displayPlaylists(for: Library.Fetch.PlaylistViewModel(playlists: playlists))
    }
    
    func presentTopSongs(response: Library.Fetch.TopSongsResponse) {
        let topSongs = response.topSongs.compactMap { Library.Fetch.TopSongsViewModel.TopSongs(artistName: $0.attributes?.artistName ?? "",
                                                                                               songName: $0.attributes?.name ?? "",
                                                                                               artworkURL: $0.attributes?.artwork?.url ?? ""
                                                                                               )
        }
        viewController?.displayTopSongs(for: Library.Fetch.TopSongsViewModel(topSongs: topSongs))
    }
    
}
