//
//  LibraryViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import UIKit
import SnapKit
import Nuke


protocol LibraryDisplayLogic: AnyObject {
    func displayPlaylists(for viewModel: Library.Fetch.PlaylistViewModel)
    func displayTopSongs(for viewModel: Library.Fetch.TopSongsViewModel)
    func displayPlaybackState(playbackState: SystemMusicPlayer.PlaybackState)
    func displaySongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation)
}

final class LibraryViewController: BaseViewController{
    
    var interactor: LibraryBusinessLogic?
    var router: (LibraryRoutingLogic & LibraryDataPassing)?
    var playlistViewModel: Library.Fetch.PlaylistViewModel?
    var topSongsViewModel: Library.Fetch.TopSongsViewModel?
    
    //MARK: - Configure UI
    
    private lazy var searchController = UISearchController()
    private lazy var tableView = UITableView().configure {
        $0.backgroundColor = Colors.background
        $0.indicatorStyle = .white
        $0.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseID)
    }
    private lazy var miniPlayer = MiniPlayerViewController().configure {
        $0.view.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.95)
        $0.view.clipsToBounds = true
        $0.view.layer.zPosition = 2
    }
    private lazy var playlistCell = LibraryPlaylistCell()
    
    // MARK: - Object lifecycle
    
    init(musicAPI: AppleMusicAPI, storefrontID: String, musicPlayer: SystemMusicPlayer) {
        super.init()
        setup(musicAPI: musicAPI, storefrontID: storefrontID, musicPlayer: musicPlayer)
    }
    
    override func loadView() {
        super.loadView()
        layoutUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchPlaylists()
        interactor?.fetchTopCharts()
        interactor?.fetchPlaybackState()
        interactor?.fetchSongDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.sizeToFit()
    }
    
    // MARK: - Setup
    
    private func setup(musicAPI: AppleMusicAPI, storefrontID: String, musicPlayer: SystemMusicPlayer) {
        let viewController = self
        let worker = LibraryWorker(musicAPI: musicAPI, storeFrontID: storefrontID)
        let interactor = LibraryInteractor(worker: worker, musicPlayer: musicPlayer)
        let presenter = LibraryPresenter()
        let router = LibraryRouter(storeFrontID: storefrontID, musicAPI: musicAPI, musicPlayer: musicPlayer)
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        tableView.delegate = self
        tableView.dataSource = self
        playlistCell.collectionView.delegate = self
        playlistCell.collectionView.dataSource = self
        miniPlayer.delegate = self
        searchController = UISearchController(searchResultsController: SearchResultsViewController(musicAPI: musicAPI, storefrontID: storefrontID, musicPlayer: musicPlayer))
    }
 
    private func layoutUI() {
        navigationItem.title = "Library"
        view.addSubview(tableView)
        addChild(miniPlayer)
        view.addSubview(miniPlayer.view)
        view.backgroundColor = Colors.background
        navigationItem.searchController = searchController
        miniPlayer.view.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(74)
            make.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
    
        searchController.searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating
        searchController.searchBar.placeholder = "Song or artist..."
    }
        
}
//MARK: - Display Logic

extension LibraryViewController: LibraryDisplayLogic {
    func displayPlaylists(for viewModel: Library.Fetch.PlaylistViewModel) {
        self.playlistViewModel = viewModel
        DispatchQueue.main.async {
            self.playlistCell.collectionView.reloadData()
        }
    }
    
    func displayTopSongs(for viewModel: Library.Fetch.TopSongsViewModel) {
        self.topSongsViewModel = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadSections([1], with: .automatic)
        }
    }
    
    func displayPlaybackState(playbackState: SystemMusicPlayer.PlaybackState) {
        let isPlaying = playbackState.status == .playing
        
        miniPlayer.playPauseImageView.image = UIImage(named: isPlaying ? "minipause" : "miniplay")
    }
    
    func displaySongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation) {
        Nuke.loadImage(with: songInfo.artworkURLSmall, into: miniPlayer.songImageView)
        miniPlayer.songNameLabel.text = songInfo.songName
    }

}

//MARK: -TableView Delegate&Datasource

extension LibraryViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(266)
        } else {
            return CGFloat(74)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.playSong(at: indexPath.row)
    }
}

extension LibraryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return topSongsViewModel?.topSongs.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return playlistCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.reuseID) as? SongCell else { fatalError("Unable to dequeue reusabla cell")}
            guard let model = topSongsViewModel?.topSongs[indexPath.row] else {
                fatalError("Cannot display model")
            }
            cell.set(for: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView().configure { $0.backgroundColor = Colors.background }
        let headerLabel = UILabel().configure {
            $0.textColor = .white
            $0.font = UIFont.preferredFont(forTextStyle: .title3)
            $0.backgroundColor = Colors.background.withAlphaComponent(0.6)
            
            if section == 0 {
                $0.text = "Playlists"
            } else {
                $0.text = "Top Songs"
            }
            
        }
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(headerView.layoutMarginsGuide)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(8)
        }
        return headerView
    }

}

//MARK: -CollectionView Delegate&DataSource

extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let globalID = playlistViewModel?.playlists[indexPath.item].globalID else { return }
        router?.routeToCatalogPlaylist(globalID: globalID)
    }
    
}

extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistViewModel?.playlists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCarouselCell.reuseID, for: indexPath) as? LibraryCarouselCell else {
            fatalError("Unable to dequeue reusable cell")
        }
        guard let model = playlistViewModel?.playlists[indexPath.row] else {
            fatalError("Cannot display model")
        }
        cell.set(for: model)
        return cell
    }
    
}

//MARK: - MiniPlayer Delegate

extension LibraryViewController: MiniPlayerDelegate {
    func playButtonTapped() {
        interactor?.play()
    }
    
    func pauseButtonTapped() {
        interactor?.pause()
    }
    
    func nextSongTapped() {
        interactor?.playNextSong()
    }
    
    func openMediaPlayer() {
        router?.routeToMediaPlayer()
    }
}

