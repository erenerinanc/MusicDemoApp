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

final class PlaylistViewController: BaseViewController {
    
    var interactor: PlaylistBusinessLogic?
    var router: (PlaylistRoutingLogic & PlaylistDataPassing)?
    var viewModel: Playlist.Fetch.ViewModel?

    var storeFrontId: String?
    var musicAPI: AppleMusicAPI?
    var nowPlayingSongID: String?
    
    private lazy var tableView = UITableView().configure {
        $0.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseID)
        $0.backgroundColor = Colors.background
        $0.indicatorStyle = .white
    }

    let headerCell = PlaylistHeaderCell()
    
    //MARK: - Object LifeCycle
    
    init(musicAPI: AppleMusicAPI) {
        super.init()
        self.musicAPI = musicAPI
        setup(musicAPI: musicAPI)
    }
    
    override func loadView() {
        super.loadView()
        layoutUI()
        showLoadingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .custom
        
        interactor?.fetchCatalogPlaylist()
        fetchNowPlayingSong()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let musicPlayer = appMusicPlayer {
            NotificationCenter.default.addObserver(
                self, selector: #selector(fetchNowPlayingSong), name: musicPlayer.playerStateDidChange, object: musicPlayer)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    
    // MARK: - Setup
    
    private func setup(musicAPI: AppleMusicAPI) {
        let viewController = self
        let worker = PlaylistWorker(musicAPI: musicAPI)
        let interactor = PlaylistInteractor(worker: worker)
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

    @objc func fetchNowPlayingSong() {
        guard let song = appMusicPlayer?.playingSongInformation else { return }
        guard let playbackState = appMusicPlayer?.playbackState else { return }
        var songIDsToReload: [String] = []
        if let oldNowPlayingID = self.nowPlayingSongID {
            songIDsToReload.append(oldNowPlayingID)
        }

        if playbackState.status == .playing {
            songIDsToReload.append(song.id)
            self.nowPlayingSongID = song.id
        } else {
            self.nowPlayingSongID = nil
        }

        var rowsToReload: [IndexPath] = []
        for songID in songIDsToReload {
            if let songIndex = viewModel?.catalogPlaylist[0].songs.firstIndex(where: { $0.id == songID }) {
                rowsToReload.append(IndexPath(row: songIndex, section: 1))
            }
        }

        tableView.reloadRows(at: rowsToReload, with: .none)
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        view.backgroundColor = Colors.background
        tableView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
    }

}

//MARK: - Display Logic

extension PlaylistViewController: PlaylistDisplayLogic {
    func displayPlaylistDetails(for viewModel: Playlist.Fetch.ViewModel) {
        self.viewModel = viewModel
        dismissLoadingView()
        guard let model = self.viewModel?.catalogPlaylist[0] else { return }
        headerCell.set(for: model)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
    }
}

//MARK: - TableView Delegate & DataSource

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let songs = viewModel?.songData else { return }
            appMusicPlayer?.songs = songs
            appMusicPlayer?.playSong(at: indexPath.row)
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
            cell.set(for: model, isPlaying: nowPlayingSongID == model.id)
            return cell
        } else {
            return headerCell
        }

    }
    
}

//MARK: - HeaderCell Delegate

extension PlaylistViewController: HeaderUserInteractionDelegate {
    func playButtonTapped() {
        guard let songs = viewModel?.songData else { return }
        appMusicPlayer?.songs = songs
        appMusicPlayer?.playSong(at: 0)
    }
    
    func imageSwiped() {
        navigationController?.popToRootViewController(animated: true)
    }
}


