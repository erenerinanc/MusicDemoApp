//
//  LibraryInteractor.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import Foundation

protocol LibraryBusinessLogic: AnyObject {
    func fetchStoreFrontID()
    func fetchPlaylists()
}

protocol LibraryDataStore: AnyObject {
    
}

final class LibraryInteractor: LibraryBusinessLogic, LibraryDataStore {
    init(musicAPI: AppleMusicAPI) {
        self.worker = LibraryWorker(musicAPI: musicAPI)
    }
    
    var presenter: LibraryPresentationLogic?
    let worker: LibraryWorkingLogic
    
    var playlists: [PlaylistData] = []
    
    //gonna use it @search request
    func fetchStoreFrontID() {
        print("Gonna fetch storefrontID...")
        worker.fetchStorefrontID { result in
            switch result {
            case .success(let response):
                guard let storefrontdata = response.data?[0] else { return }
                guard let storefrontid = storefrontdata.id else { return }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchPlaylists() {
        print("Gonna fetch playlists...")
        worker.fetchPlaylists { result in
            switch result {
            case .success(let response):
                guard let data = response.data else { return }
                self.playlists = data
                self.presenter?.presentPlaylists(response: Library.Fetch.Response(playlists: self.playlists))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
