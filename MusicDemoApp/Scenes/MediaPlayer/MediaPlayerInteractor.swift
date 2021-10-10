//
//  MediaPlayerInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol MediaPlayerBusinessLogic: AnyObject {
    func getSongs()
}

protocol MediaPlayerDataStore: AnyObject {
    var songData: [SongData]? {get set}
    
}

final class MediaPlayerInteractor: MediaPlayerBusinessLogic, MediaPlayerDataStore {
    
    var presenter: MediaPlayerPresentationLogic?
    var worker: MediaPlayerWorkingLogic = MediaPlayerWorker()
    
    var songData: [SongData]?
    
    func getSongs() {
        guard let songData = songData else { return }
        presenter?.presentSongDetails(response: MediaPlayer.Fetch.Response(songs: songData))
    }

    
}
