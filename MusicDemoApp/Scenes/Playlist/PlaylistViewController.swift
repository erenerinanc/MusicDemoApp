//
//  PlaylistViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import UIKit
import SnapKit
import Nuke
import MediaPlayer
import SwiftUI

protocol PlaylistDisplayLogic: AnyObject {
    func displayPlaylistDetails(for viewModel: Playlist.Fetch.ViewModel)
    
}

protocol PlayButtonDelegate {
    func playButtonTapped()
}

public var musicPlayer = MPMusicPlayerController.systemMusicPlayer

final class PlaylistViewController: BaseViewController {
    
    var interactor: PlaylistBusinessLogic?
    var router: (PlaylistRoutingLogic & PlaylistDataPassing)?
    var viewModel: Playlist.Fetch.ViewModel?
    var globalId: String?
    var storeFrontId: String?
    
    var tableView = UITableView()
    let headerCell = HeaderImageCell()
    
    //MARK: Object LifeCycle
    
    init(musicAPI: AppleMusicAPI, storeFrontID: String, globalID: String) {
        super.init()
        self.storeFrontId = storeFrontID
        self.globalId = globalID
        setup(musicAPI: musicAPI)
    }
    
    // MARK: Setup
    
    private func setup(musicAPI: AppleMusicAPI) {
        let viewController = self
        let interactor = PlaylistInteractor(musicAPI: musicAPI)
        let presenter = PlaylistPresenter()
        let router = PlaylistRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        tableView.delegate = self
        tableView.dataSource = self
        headerCell.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        guard let storeFrontId = storeFrontId else { return }
        guard let globalId = globalId else { return }
        interactor?.fetchCatalogPlaylist(request: Playlist.Fetch.Request(storeFrontID: storeFrontId, globalID: globalId))
        layoutUI()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
        tableView.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseID)
        tableView.backgroundColor = Colors.background
        tableView.indicatorStyle = .white
    }
}

extension PlaylistViewController: PlaylistDisplayLogic {
    func displayPlaylistDetails(for viewModel: Playlist.Fetch.ViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            self.tableView.reloadData()
            guard let model = self.viewModel?.catalogPlaylist[0] else { return }
            self.headerCell.set(for: model)
        }
    }
}

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let songID = viewModel?.songs[indexPath.row].id {
            musicPlayer.setQueue(with: [songID])
            musicPlayer.play()
        }
        //route to mediplayer scene
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(400)
        } else {
            return CGFloat(74)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

}

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel?.songs.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.reuseID) as? SongCell else {
                fatalError("Unable to dequeue reusable cell")
            }
            guard let model = viewModel?.songs[indexPath.row] else {
                fatalError("Unable to display model")
            }
            cell.set(for: model)
            return cell
        } else {
            return headerCell
        }

    }
    
}

extension PlaylistViewController: PlayButtonDelegate {
    func playButtonTapped() {
        print("Play the songs")
        var songIds: [String] = []
        viewModel?.songs.forEach({
            songIds.append($0.id)
        })
        musicPlayer.setQueue(with: songIds)
        musicPlayer.play()
    }
}
