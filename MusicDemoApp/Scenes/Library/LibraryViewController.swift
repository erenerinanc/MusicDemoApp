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
    func displayPlaylists(for viewModel: Library.Fetch.ViewModel)
}

final class LibraryViewController: BaseViewController {
    
    var interactor: LibraryBusinessLogic?
    var router: (LibraryRoutingLogic & LibraryDataPassing)?
    var viewModel: Library.Fetch.ViewModel?
    
    lazy var searchController = UISearchController(searchResultsController: SearchResultsViewController())
    private lazy var tableView = UITableView()
    private lazy var playlistCell = PlaylistCell()
    
    // MARK: Object lifecycle
    
    init(musicAPI: AppleMusicAPI) {
        super.init()
        setup(musicAPI: musicAPI)
    }
    
    // MARK: Setup
    
    private func setup(musicAPI: AppleMusicAPI) {
        let viewController = self
        let interactor = LibraryInteractor(musicAPI: musicAPI)
        let presenter = LibraryPresenter()
        let router = LibraryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        askForPermission()
    }
    
    private func layoutUI() {
        navigationItem.title = "Library"
        view.addSubview(tableView)
        tableView.backgroundColor = Colors.background
        tableView.indicatorStyle = .white
        tableView.snp.makeConstraints { $0.directionalEdges.equalToSuperview()}
        tableView.register(FavoriteSongCell.self, forCellReuseIdentifier: FavoriteSongCell.reuseID)
    }
    
    private func askForPermission() {
        SKCloudServiceController.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.interactor?.fetchPlaylists()
                } else {
                    let alertVC = UIAlertController(title: "Apple Music Permission Required", message: "Hebelek", preferredStyle: .alert)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
        
  
}

extension LibraryViewController: LibraryDisplayLogic {
    func displayPlaylists(for viewModel: Library.Fetch.ViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.playlistCell.collectionView.reloadData()
            self.tableView.reloadSections([1], with: .automatic)
        }
    }
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(266)
        } else {
            return CGFloat(50 + 24)
        }
    }
}

extension LibraryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return playlistCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteSongCell.reuseID) as? FavoriteSongCell else { fatalError("Unable to dequeue reusabla cell")}
            cell.songNameLabel.text = "Low Earth Orbit"
            cell.subtitleLabel.text = "A Synthwave Mix"
            return cell
        }
    }
    
    
}

