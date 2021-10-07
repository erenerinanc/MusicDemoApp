//
//  MediaPlayerViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import UIKit
import SnapKit
import MediaPlayer
import Nuke

enum PlayerButton {
    case replay
    case previous
    case next
    case play
    case pause
    case volume
}

protocol MediaPlayerDisplayLogic: AnyObject {
    func displayPlaylistSongDetail(viewModel: MediaPlayer.Fetch.PlaylistViewModel)
    func displayTopSongDetail(viewModel: MediaPlayer.Fetch.TopSongViewModel)
}

protocol PlayerViewDelegate {
    func buttonTapped(with button: PlayerButton)
}

final class MediaPlayerViewController: BaseViewController {
    
    var interactor: MediaPlayerBusinessLogic?
    var router: (MediaPlayerRoutingLogic & MediaPlayerDataPassing)?
    var songID: String?
    var songImageview = UIImageView()
    var swipeView = UIView()
    var songNameLabel = UILabel()
    var descriptionLabel = UILabel()
    var playerView = PlayerView()
    var playlistViewModel: MediaPlayer.Fetch.PlaylistViewModel?
    var topSongViewModel: MediaPlayer.Fetch.TopSongViewModel?
    var presentIndex: Int?
    
    // MARK: Object lifecycle
    
    init(index: Int) {
        super.init()
        self.presentIndex = index
        setup()
    }
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MediaPlayerInteractor()
        let presenter = MediaPlayerPresenter()
        let router = MediaPlayerRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        playerView.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        layoutUI()
    }
    
    private func layoutUI() {
        view.backgroundColor = Colors.background
        view.addSubview(swipeView)
        view.addSubview(songImageview)
        view.addSubview(songNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(playerView)
        
        swipeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(4)
        }
        
        swipeView.backgroundColor = Colors.secondaryBackground
        swipeView.layer.cornerRadius = CGFloat(5)
        
        songImageview.snp.makeConstraints { make in
            make.top.equalTo(swipeView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.height.equalTo(songImageview.snp.width)
        }
        songImageview.backgroundColor = Colors.background
        songImageview.contentMode = .scaleAspectFit
        songImageview.layer.cornerRadius = CGFloat(150)
        songImageview.clipsToBounds = true
        songImageview.layer.borderWidth = 3.0
        songImageview.layer.borderColor = Colors.primaryLabel.cgColor
        
        songNameLabel.snp.makeConstraints { make in
            make.top.equalTo(songImageview.snp.bottom).offset(16)
            make.centerX.equalTo(songImageview.snp.centerX)
        }
        songNameLabel.textColor = .white
        songNameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(16)
            make.centerX.equalTo(songNameLabel.snp.centerX)
        }
        descriptionLabel.textColor = Colors.background
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        playerView.playButton.image = UIImage(named: "pause")
        
    }
}

//MARK: - Display Logic
extension MediaPlayerViewController: MediaPlayerDisplayLogic {
    
    func displayPlaylistSongDetail(viewModel: MediaPlayer.Fetch.PlaylistViewModel) {
        DispatchQueue.main.async {
            self.playlistViewModel = viewModel
            guard let index = self.presentIndex else { return }
            let artworkURL = viewModel.playlistData[index].artworkURL.replacingOccurrences(of: "{w}", with: "3000").replacingOccurrences(of: "{h}", with: "3000")
            Nuke.loadImage(with: artworkURL, into: self.songImageview)
            self.songNameLabel.text = musicPlayer.nowPlayingItem?.title
            self.descriptionLabel.text = viewModel.playlistData[index].label
        }
    }
    
    func displayTopSongDetail(viewModel: MediaPlayer.Fetch.TopSongViewModel) {
        DispatchQueue.main.async {
            self.topSongViewModel = viewModel
            guard let index = self.presentIndex else { return }
            let artworkURL = viewModel.topSongData[index].artworkURL.replacingOccurrences(of: "{w}", with: "3000").replacingOccurrences(of: "{h}", with: "3000")
            Nuke.loadImage(with: artworkURL, into: self.songImageview)
            self.songNameLabel.text = musicPlayer.nowPlayingItem?.title
            self.descriptionLabel.text = "Top Charts"
        }
    }
}

extension MediaPlayerViewController: PlayerViewDelegate {

    func buttonTapped(with button: PlayerButton) {
        switch button {
        case .replay:
            musicPlayer.repeatMode = .one
        case .previous:
            musicPlayer.skipToPreviousItem()
        case .next:
            musicPlayer.skipToNextItem()
        case .play:
            musicPlayer.play()
            playerView.playButton.image = UIImage(named: "pause")
        case .pause:
            musicPlayer.pause()
            playerView.playButton.image = UIImage(named: "play")
        case .volume:
            break
        }
    }
}
