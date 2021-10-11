//
//  SearchResultsViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import Cryptor
import SnapKit
import SafariServices

protocol SearchResultsDisplayLogic: AnyObject {
    func displaySearchResults(for viewModel: SearchResults.Fetch.SongViewModel)
    func displaySearchResults(for viewModel: SearchResults.Fetch.ArtistViewModel)
}

final class SearchResultsViewController: BaseViewController {
    
    var interactor: SearchResultsBusinessLogic?
    var router: (SearchResultsRoutingLogic & SearchResultsDataPassing)?
    var songViewModel: SearchResults.Fetch.SongViewModel?
    var artistViewModel: SearchResults.Fetch.ArtistViewModel?
    
    lazy var tableView = UITableView().configure {
        $0.indicatorStyle = .white
        $0.backgroundColor = Colors.background
        $0.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseID)
    }

    // MARK: Object lifecycle
    
    init(musicAPI: AppleMusicAPI, storefrontID: String) {
        super.init()
        setup(musicAPI: musicAPI, storefrontID: storefrontID)
    }
    
    // MARK: Setup
    
    private func setup(musicAPI: AppleMusicAPI, storefrontID: String) {
        let viewController = self
        let interactor = SearchResultsInteractor(musicAPI: musicAPI, storeFrontID: storefrontID)
        let presenter = SearchResultsPresenter()
        let router = SearchResultsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func loadView() {
        super.loadView()
        layoutUI()
     
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        view.backgroundColor = Colors.background
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.trailing.equalToSuperview()
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
            make.leading.trailing.equalTo(headerView.layoutMarginsGuide)
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
            cell.set(for: model)
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
        if indexPath.section == 0{
            router?.routeToSong(index: indexPath.row)
        } else {
            guard let urlString = artistViewModel?.artists[indexPath.row].url else { return }
            let destVC = ArtistDetailsViewController(url: urlString)
            navigationController?.pushViewController(destVC, animated: true)
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
        DispatchQueue.main.async {
            self.songViewModel = viewModel
            self.tableView.reloadData()
        }
    }
    
    func displaySearchResults(for viewModel: SearchResults.Fetch.ArtistViewModel) {
        DispatchQueue.main.async {
            self.artistViewModel = viewModel
            self.tableView.reloadData()
        }
    }
    
}
