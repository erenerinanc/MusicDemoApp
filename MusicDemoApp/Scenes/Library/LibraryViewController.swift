//
//  LibraryViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import UIKit
import SnapKit

protocol LibraryDisplayLogic: AnyObject {
    func displayPlaylists(for viewModel: Library.Fetch.ViewModel)
}

final class LibraryViewController: UIViewController {
    
    var interactor: LibraryBusinessLogic?
    var router: (LibraryRoutingLogic & LibraryDataPassing)?
    var viewModel: Library.Fetch.ViewModel?
    
    lazy var searchController = UISearchController(searchResultsController: SearchResultsViewController())
    private lazy var tableView = UITableView()
    private lazy var playlistCell = PlaylistCell()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = LibraryInteractor()
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

    }
    
    private func layoutUI() {
        navigationItem.title = "Library"
        view.addSubview(tableView)
        tableView.backgroundColor = Colors.background
        tableView.indicatorStyle = .white
        tableView.snp.makeConstraints { $0.directionalEdges.equalToSuperview()}
        tableView.register(FavoriteSongCell.self, forCellReuseIdentifier: FavoriteSongCell.reuseID)
    }
}

extension LibraryViewController: LibraryDisplayLogic {
    func displayPlaylists(for viewModel: Library.Fetch.ViewModel) {
        
    }
}

extension LibraryViewController: UITableViewDelegate {
    
}

extension LibraryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return playlistCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteSongCell.reuseID) else { fatalError("Unable to dequeue reusabla cell")}
            return cell
            
        }
    }
    
    
}

