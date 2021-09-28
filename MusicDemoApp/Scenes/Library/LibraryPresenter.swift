//
//  LibraryPresenter.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryPresentationLogic: AnyObject {
    func presentPlaylists(response: Library.Fetch.Response)
}

final class LibraryPresenter: LibraryPresentationLogic {

    weak var viewController: LibraryDisplayLogic?
    
    func presentPlaylists(response: Library.Fetch.Response) {
        let playlists = response.playlists.compactMap {  Library.Fetch.ViewModel.Playlist(artworkURL: $0.attributes?.artwork?.url ?? "",
                                                                                          playlistName: $0.attributes?.name ?? "",
                                                                                          songCount: 40
            )
        }
        viewController?.displayPlaylists(for: Library.Fetch.ViewModel(playlists: playlists))
    }
    
}
