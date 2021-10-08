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
    var progressStackView = ProgressStackView()
    var playerView = PlayerView()
    var playlistViewModel: MediaPlayer.Fetch.PlaylistViewModel?
    var topSongViewModel: MediaPlayer.Fetch.TopSongViewModel?
    var presentIndex: Int = 0
    var isDisplayingPlaylistSongs: Bool = true
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProgressView()
    }
 
    
    private func layoutUI() {
        view.backgroundColor = Colors.background
        view.addSubview(swipeView)
        view.addSubview(songImageview)
        view.addSubview(songNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(progressStackView)
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
        descriptionLabel.textColor = Colors.secondaryLabel
        
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(progressStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        playerView.playButton.image = UIImage(named: "pause")
        
    }
    
    private func configureProgressView() {
        progressStackView.progressView.progress = 0.0
        guard let songDuration = musicPlayer.nowPlayingItem?.playbackDuration else { return }
        let trackElapsed = musicPlayer.currentPlaybackTime
        
        let trackDurationMinutes = Double(songDuration / 60)
        let trackDurationSeconds = songDuration.truncatingRemainder(dividingBy: 60)
        let trackDurationInt = Int(trackDurationSeconds)
        progressStackView.songDurationLabel.text = "\(trackDurationMinutes):\(trackDurationInt)"
    
        let trackElapsedMinutes = Double(trackElapsed / 60)
        let trackElapsedSeconds = trackElapsed.truncatingRemainder(dividingBy: 60)
        let trackElapsedInt = Int(trackElapsedSeconds)
        progressStackView.durationLabel.text = "\(trackElapsedMinutes):\(trackElapsedInt)"
        
    }
}

//MARK: - Display Logic
extension MediaPlayerViewController: MediaPlayerDisplayLogic {
    
    func displayPlaylistSongDetail(viewModel: MediaPlayer.Fetch.PlaylistViewModel) {
        DispatchQueue.main.async {
            self.playlistViewModel = viewModel
//            guard let index = self.presentIndex else { return }
            let artworkURL = viewModel.playlistData[self.presentIndex].artworkURL.resizeWidhtAndHeight(width: 3000, height: 3000)
            Nuke.loadImage(with: artworkURL, into: self.songImageview)
            self.songNameLabel.text = musicPlayer.nowPlayingItem?.title
            self.descriptionLabel.text = viewModel.playlistData[self.presentIndex].label
        }
    }
    
    func displayTopSongDetail(viewModel: MediaPlayer.Fetch.TopSongViewModel) {
        DispatchQueue.main.async {
            self.topSongViewModel = viewModel
//            guard let index = self.presentIndex else { return }
            let artworkURL = viewModel.topSongData[self.presentIndex].artworkURL.resizeWidhtAndHeight(width: 3000, height: 3000)
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
            if isDisplayingPlaylistSongs {
                guard var songIds = playlistViewModel?.playlistData.compactMap({  $0.id }) else { return }
                let songID = songIds[presentIndex]
                guard let index = songIds.firstIndex(of: songID) else { return }
                songIds.removeFirst(index)
                musicPlayer.setQueue(with: songIds)
                guard let model = playlistViewModel else { return }
                displayPlaylistSongDetail(viewModel: model)
            } else {
                guard var songIds = topSongViewModel?.topSongData.compactMap({  $0.id }) else { return }
                let songID = songIds[presentIndex]
                guard let index = songIds.firstIndex(of: songID) else { return }
                songIds.removeFirst(index)
                musicPlayer.setQueue(with: songIds)
                guard let model = topSongViewModel else { return }
                displayTopSongDetail(viewModel: model)
            }
            musicPlayer.play()
        case .previous:
            if presentIndex > 0 {
                presentIndex -= 1
            } else {
                presentIndex = 0
            }
            if isDisplayingPlaylistSongs {
                guard var songIds = playlistViewModel?.playlistData.compactMap({  $0.id }) else { return }
                let songID = songIds[presentIndex]
                guard let index = songIds.firstIndex(of: songID) else { return }
                songIds.removeFirst(index)
                musicPlayer.setQueue(with: songIds)
                guard let model = playlistViewModel else { return }
                displayPlaylistSongDetail(viewModel: model)
            } else {
                guard var songIds = topSongViewModel?.topSongData.compactMap({  $0.id }) else { return }
                let songID = songIds[presentIndex]
                guard let index = songIds.firstIndex(of: songID) else { return }
                songIds.removeFirst(index)
                musicPlayer.setQueue(with: songIds)
                guard let model = topSongViewModel else { return }
                displayTopSongDetail(viewModel: model)
            }
            musicPlayer.play()
        case .next:
            presentIndex += 1
            if isDisplayingPlaylistSongs {
                guard var songIds = playlistViewModel?.playlistData.compactMap({  $0.id }) else { return }
                let songID = songIds[presentIndex]
                guard let index = songIds.firstIndex(of: songID) else { return }
                songIds.removeFirst(index)
                musicPlayer.setQueue(with: songIds)
                guard let model = playlistViewModel else { return }
                displayPlaylistSongDetail(viewModel: model)
            } else {
                guard var songIds = topSongViewModel?.topSongData.compactMap({  $0.id }) else { return }
                let songID = songIds[presentIndex]
                guard let index = songIds.firstIndex(of: songID) else { return }
                songIds.removeFirst(index)
                musicPlayer.setQueue(with: songIds)
                guard let model = topSongViewModel else { return }
                displayTopSongDetail(viewModel: model)
            }
            musicPlayer.play()
            
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
