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
    func displayPlaybackState(playbackState: SystemMusicPlayer.PlaybackState)
    func displaySongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation)
    
}

final class PlaylistViewController: BaseViewController {
    
    var interactor: PlaylistBusinessLogic?
    var router: (PlaylistRoutingLogic & PlaylistDataPassing)?
    var viewModel: Playlist.Fetch.ViewModel?

    var storeFrontId: String?
    var musicAPI: AppleMusicAPI?
    
    private lazy var tableView = UITableView().configure {
        $0.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseID)
        $0.backgroundColor = Colors.background
        $0.indicatorStyle = .white
    }

    let headerCell = PlaylistHeaderCell()
    
    //MARK: - Object LifeCycle
    
    init(musicAPI: AppleMusicAPI, musicPlayer: SystemMusicPlayer) {
        super.init()
        self.musicAPI = musicAPI
        setup(musicAPI: musicAPI, musicPlayer: musicPlayer)
    }

    
    // MARK: - Setup
    
    private func setup(musicAPI: AppleMusicAPI, musicPlayer: SystemMusicPlayer) {
        let viewController = self
        let worker = PlaylistWorker(musicAPI: musicAPI)
        let interactor = PlaylistInteractor(worker: worker, musicPlayer: musicPlayer)
        let presenter = PlaylistPresenter()
        let router = PlaylistRouter(musicPlayer: musicPlayer)
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
        layoutUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .custom
        
        interactor?.fetchCatalogPlaylist()
        interactor?.fetchPlaybackState()
        interactor?.fetchSongDetails()
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
    
    func displayPlaybackState(playbackState: SystemMusicPlayer.PlaybackState) {
        let isPlaying = playbackState.status == .playing
        
        headerCell.playButtonImageView.image = UIImage(named: isPlaying ? "pause" : "play")

    }
    
    func displaySongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation) {
       
    }
}

//MARK: - TableView Delegate & DataSource

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            headerCell.playButtonImageView.image = UIImage(named: "pause")
            headerCell.isPlayTapped = true
            interactor?.playSong(at: indexPath.row)
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
            return viewModel?.catalogPlaylist[0].songs.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.reuseID) as? SongCell else {
                fatalError("Unable to dequeue reusable cell")
            }
            guard let model = viewModel?.catalogPlaylist[0].songs[indexPath.row] else {
                fatalError("Unable to display model")
            }
            cell.set(for: model)
            return cell
        } else {
            return headerCell
        }

    }
    
}

//MARK: - HeaderCell Delegate

extension PlaylistViewController: HeaderUserInteractionDelegate {
    func playButtonTapped() {
        interactor?.play()
    }
    
    func pauseButtonTapped() {
        interactor?.pause()
    }
    
    func imageSwiped() {
        navigationController?.popToRootViewController(animated: true)
    }
}


