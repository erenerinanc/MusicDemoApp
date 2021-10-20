//
//  SearchResultsViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import SnapKit


protocol SearchResultsDisplayLogic: AnyObject {
    func displaySearchResults(for viewModel: SearchResults.Fetch.SongViewModel)
    func displaySearchResults(for viewModel: SearchResults.Fetch.ArtistViewModel)
    func displayNowPlayingSong(_ song: SystemMusicPlayer.PlayingSongInformation, isPlaying: Bool)
}

final class SearchResultsViewController: BaseViewController {
    
    var interactor: SearchResultsBusinessLogic?
    var router: (SearchResultsRoutingLogic & SearchResultsDataPassing)?
    var songViewModel: SearchResults.Fetch.SongViewModel?
    var artistViewModel: SearchResults.Fetch.ArtistViewModel?
    var nowPlayingSongID: String?
    
    private lazy var tableView = UITableView().configure {
        $0.indicatorStyle = .white
        $0.backgroundColor = Colors.background
        $0.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseID)
    }

    // MARK: - Object lifecycle
    
    init(musicAPI: AppleMusicAPI, storefrontID: String, musicPlayer: SystemMusicPlayer) {
        super.init()
        setup(musicAPI: musicAPI, storefrontID: storefrontID, musicPlayer: musicPlayer)
    }
    
    override func loadView() {
        super.loadView()
        layoutUI()
        configureKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchNowPlayingSong()
    }
    
    // MARK: - Setup
    
    private func setup(musicAPI: AppleMusicAPI, storefrontID: String, musicPlayer: SystemMusicPlayer) {
        let viewController = self
        let worker = SearchResultsWorker(musicAPI: musicAPI, storeFrontID: storefrontID)
        let interactor = SearchResultsInteractor(worker: worker, musicPlayer: musicPlayer)
        let presenter = SearchResultsPresenter()
        let router = SearchResultsRouter(musicPlayer: musicPlayer)
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        view.backgroundColor = Colors.background
        tableView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
    }
    
    private func configureKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
        
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 30, right: 0)
            tableView.contentInset = contentInsets
        }
    }
    
}

//MARK: - TableView Delegate&DataSource

extension SearchResultsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView().configure { $0.backgroundColor = Colors.background }
        let headerLabel = UILabel().configure {
            $0.textColor = .white
            $0.font = UIFont.preferredFont(forTextStyle: .title3)
            $0.backgroundColor = Colors.background.withAlphaComponent(0.6)
            if section == 0 {
                $0.text = "Songs"
            } else {
                $0.text = "Artists"
            }
            
        }
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(headerView.layoutMarginsGuide)
            make.leading.equalTo(headerView.layoutMarginsGuide).inset(4)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(8)
        }
        return headerView
    }
    
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return songViewModel?.songs.count ?? 0
        } else {
            return artistViewModel?.artists.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.reuseID) as? SongCell else { fatalError("Unable to dequeue reusable cell") }
        if indexPath.section == 0 {
            guard let model = songViewModel?.songs[indexPath.row] else { fatalError("Unable to display songs") }
            cell.set(for: model, isPlaying: nowPlayingSongID == model.id)
        } else {
            guard let model = artistViewModel?.artists[indexPath.row] else { fatalError("Unable to display artists") }
            cell.set(for: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(74)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            interactor?.playSong(at: indexPath.row)
        } else {
            guard let urlString = artistViewModel?.artists[indexPath.row].url else { return }
            router?.routeToArtistDetail(with: urlString)
        }
    }
}

//MARK: - Search Results Updating

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else { return }
        interactor?.fetchSearchResults(request: SearchResults.Fetch.Request(searchQuery: searchQuery))
    }
}

//MARK: - Display Logic

extension SearchResultsViewController: SearchResultsDisplayLogic {
    func displaySearchResults(for viewModel: SearchResults.Fetch.SongViewModel) {
        songViewModel = viewModel
        tableView.reloadData()
    }
    
    func displaySearchResults(for viewModel: SearchResults.Fetch.ArtistViewModel) {
        artistViewModel = viewModel
        tableView.reloadData()
    }
    
    func displayNowPlayingSong(_ song: SystemMusicPlayer.PlayingSongInformation, isPlaying: Bool) {
        var songIDsToReload: [String] = []
        if let oldNowPlayingID = self.nowPlayingSongID {
            songIDsToReload.append(oldNowPlayingID)
        }
        
        if isPlaying {
            songIDsToReload.append(song.id)
            self.nowPlayingSongID = song.id
        } else {
            self.nowPlayingSongID = nil
        }
        
        var rowsToReload: [IndexPath] = []
        for songID in songIDsToReload {
            if let songIndex = songViewModel?.songs.firstIndex(where: { $0.id == songID }) {
                rowsToReload.append(IndexPath(row: songIndex, section: 0))
            }
        }
        
        tableView.reloadRows(at: rowsToReload, with: .none)
    }
    
}
