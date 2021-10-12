//
//  LibraryViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import UIKit
import SnapKit
import StoreKit

protocol LibraryDisplayLogic: AnyObject {
    func displayPlaylists(for viewModel: Library.Fetch.PlaylistViewModel)
    func displayTopSongs(for viewModel: Library.Fetch.TopSongsViewModel)
}

final class LibraryViewController: BaseViewController{
    
    var interactor: LibraryBusinessLogic?
    var router: (LibraryRoutingLogic & LibraryDataPassing)?
    var playlistViewModel: Library.Fetch.PlaylistViewModel?
    var topSongsViewModel: Library.Fetch.TopSongsViewModel?
    
    //MARK: -Configure UI Views
    
    private lazy var searchController = UISearchController().configure {
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.placeholder = "Song or artist..."
    }
    private lazy var tableView = UITableView().configure {
        $0.backgroundColor = Colors.background
        $0.indicatorStyle = .white
        $0.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseID)
    }
    private lazy var playlistCell = LibraryPlaylistCell()
    
    // MARK: -Object lifecycle
    
    init(musicAPI: AppleMusicAPI, storefrontID: String) {
        super.init()
        setup(musicAPI: musicAPI, storefrontID: storefrontID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        interactor?.fetchPlaylists()
        interactor?.fetchTopCharts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.sizeToFit()
    }
    
    // MARK: -Setup
    
    private func setup(musicAPI: AppleMusicAPI, storefrontID: String) {
        let viewController = self
        let interactor = LibraryInteractor(musicAPI: musicAPI,storeFrontID: storefrontID)
        let presenter = LibraryPresenter()
        let router = LibraryRouter(storeFrontID: storefrontID, musicAPI: musicAPI)
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
        searchController = UISearchController(searchResultsController: SearchResultsViewController(musicAPI: musicAPI, storefrontID: storefrontID))
    }
 
    private func layoutUI() {
        navigationItem.title = "Library"
        view.addSubview(tableView)
        view.backgroundColor = Colors.background
        navigationItem.searchController = searchController
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.trailing.equalToSuperview()
        }
        searchController.searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating
    }
        
}
//MARK: -Display Logic

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
}

//MARK: -TableView Delegate&Datasource

extension LibraryViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(276)
        } else {
            return CGFloat(74)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToSong(index: indexPath.row)
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
        guard let globalID = playlistViewModel?.playlists[indexPath.item].id else { return }
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

