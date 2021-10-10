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

protocol HeaderUserInteractionDelegate {
    func playButtonTapped()
    func pauseButtonTapped()
    func imageSwiped()
}

public var musicPlayer = MPMusicPlayerController.systemMusicPlayer

final class PlaylistViewController: BaseViewController {
    
    var interactor: PlaylistBusinessLogic?
    var router: (PlaylistRoutingLogic & PlaylistDataPassing)?
    var viewModel: Playlist.Fetch.ViewModel?
    var globalId: String?
    var storeFrontId: String?
    var musicAPI: AppleMusicAPI?
    
    var tableView = UITableView()
    let headerCell = HeaderImageCell()
    
    //MARK: Object LifeCycle
    
    init(musicAPI: AppleMusicAPI, storeFrontID: String, globalID: String) {
        super.init()
        self.musicAPI = musicAPI
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

//MARK: - Display Logic

extension PlaylistViewController: PlaylistDisplayLogic {
    func displayPlaylistDetails(for viewModel: Playlist.Fetch.ViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            guard let model = self.viewModel?.catalogPlaylist[0] else { return }
            self.headerCell.set(for: model)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
            }
        }
    }
}

//MARK: - TableView Delegate & DataSource

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            headerCell.playButtonImage.image = UIImage(named: "pause")
            headerCell.isButtonTapped = true
            router?.routeToSongs(index: indexPath.row)
        }
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

//MARK: - Play&Pause Button Delegate

extension PlaylistViewController: HeaderUserInteractionDelegate {
    func playButtonTapped() {
        print("Play the songs")
        var songIds: [String] = []
        viewModel?.songs.forEach({
            songIds.append($0.id)
        })
        headerCell.isButtonTapped = true
        musicPlayer.setQueue(with: songIds)
        musicPlayer.play()
        headerCell.playButtonImage.image = UIImage(named: "pause")
    }
    
    func pauseButtonTapped() {
        print("Stop playing")
        headerCell.isButtonTapped = false
        musicPlayer.stop()
        headerCell.playButtonImage.image = UIImage(named: "play")
    }
    
    func imageSwiped() {
        print("Routing back to Library Scene")
        navigationController?.popToRootViewController(animated: true)
    }
}
