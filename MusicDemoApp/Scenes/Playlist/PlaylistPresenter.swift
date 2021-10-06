//
//  PlaylistPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol PlaylistPresentationLogic: AnyObject {
    func presentCatalogPlaylist(response: Playlist.Fetch.Response)
}

final class PlaylistPresenter: PlaylistPresentationLogic {
    
    weak var viewController: PlaylistDisplayLogic?
    
    func presentCatalogPlaylist(response: Playlist.Fetch.Response) {
        let catalogPlaylist = response.catalogPlaylistData.compactMap { Playlist.Fetch.ViewModel.CatalogPlaylist(artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                                                 name: $0.attributes?.name ?? "",
                                                                                                                 description: "50 Songs 102 hours")
        }
        let catalogSongs = response.catalogSongData.compactMap { Playlist.Fetch.ViewModel.Song(songURL: $0.attributes?.previews?[0].url ?? "",
                                                                                               name: $0.attributes?.name ?? "",
                                                                                               description: $0.attributes?.artistName ?? "",
                                                                                               artworkURL: $0.attributes?.artwork?.url ?? "",id: $0.id ?? ""
        )
        }
        viewController?.displayPlaylistDetails(for: Playlist.Fetch.ViewModel(catalogPlaylist: catalogPlaylist, songs: catalogSongs))
      
    }
}
