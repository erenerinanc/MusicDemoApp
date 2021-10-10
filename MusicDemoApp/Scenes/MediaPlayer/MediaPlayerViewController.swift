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
    func displaySongDetail(viewModel: MediaPlayer.Fetch.ViewModel)
}

protocol PlayerViewDelegate {
    func buttonTapped(with button: PlayerButton)
}

final class MediaPlayerViewController: BaseViewController {
    
    var interactor: MediaPlayerBusinessLogic?
    var router: (MediaPlayerRoutingLogic & MediaPlayerDataPassing)?
    var viewModel: MediaPlayer.Fetch.ViewModel?
    
    var songID: String?
    var songImageview = UIImageView()
    var swipeView = UIView()
    var songNameLabel = UILabel()
    var descriptionLabel = UILabel()
    var progressView = ProgressView()
    var playerView = PlayerView()
    
    var presentIndex: Int = 0
    let volumeView = MPVolumeView()
    let contentView = UIView()
    var volumetapped: Bool = false
    
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
        interactor?.getSongs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    private func layoutUI() {
        view.backgroundColor = Colors.background
        view.addSubview(swipeView)
        view.addSubview(songImageview)
        view.addSubview(songNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(progressView)
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
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        playerView.playButton.image = UIImage(named: "pause")
        
    }
    
    private func setMediaPlayer() {
        guard var songIds = viewModel?.songs.compactMap({ $0.id }) else { return }
        let songID = songIds[presentIndex]
        guard let index = songIds.firstIndex(of: songID) else { return }
        songIds.removeFirst(index)
        musicPlayer.setQueue(with: songIds)
        musicPlayer.play()
        let artworkURL = viewModel?.songs[self.presentIndex].artworkURL.resizeWidhtAndHeight(width: 3000, height: 3000)
        Nuke.loadImage(with: artworkURL, into: self.songImageview)
        songNameLabel.text = musicPlayer.nowPlayingItem?.title
        descriptionLabel.text = musicPlayer.nowPlayingItem?.artist
        configureProgressView()
    }
    
    private func configureProgressView() {
        progressView.progressView.progress = 0.0
        guard let songDuration = musicPlayer.nowPlayingItem?.playbackDuration else { return }
        let trackElapsed = musicPlayer.currentPlaybackTime
        
        let trackDurationMinutes = Int(songDuration / 60)
        let trackDurationSeconds = songDuration.truncatingRemainder(dividingBy: 60)
        let trackDurationInt = Int(trackDurationSeconds)
        progressView.songDurationLabel.text = "\(trackDurationMinutes):\(trackDurationInt)"
    
        let trackElapsedMinutes = Int(trackElapsed / 60)
        let trackElapsedSeconds = trackElapsed.truncatingRemainder(dividingBy: 60)
        let trackElapsedInt = Int(trackElapsedSeconds)
        progressView.durationLabel.text = "\(trackElapsedMinutes):\(trackElapsedInt)"
        
        
    }
    
    private func configureVolumeview() {
        contentView.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.7)
        view.addSubview(contentView)
        contentView.addSubview(volumeView)
        contentView.layer.cornerRadius = CGFloat(30)
        contentView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(100)
        }
        volumeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(contentView.snp.centerY).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(30)
        }
        volumeView.tintColor = Colors.secondaryLabel
        volumeView.sizeToFit()
        if volumetapped == true {
            let tapRecognizer = UITapGestureRecognizer()
            view.addGestureRecognizer(tapRecognizer)
            tapRecognizer.addTarget(self, action: #selector(dismissVolumeView))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismissVolumeView()
        }
    }
    
    @objc func dismissVolumeView() {
        contentView.removeFromSuperview()
        volumetapped = false
    }
    

}

//MARK: - Display Logic
extension MediaPlayerViewController: MediaPlayerDisplayLogic {
    
    func displaySongDetail(viewModel: MediaPlayer.Fetch.ViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
            self.setMediaPlayer()
        }
    }
}

extension MediaPlayerViewController: PlayerViewDelegate {

    func buttonTapped(with button: PlayerButton) {
        switch button {
        case .replay:
            setMediaPlayer()
        case .previous:
            if presentIndex > 0 {
                presentIndex -= 1
            } else {
                presentIndex = 0
            }
            setMediaPlayer()
        case .next:
            presentIndex += 1
            setMediaPlayer()
        case .play:
            musicPlayer.play()
            playerView.playButton.image = UIImage(named: "pause")
        case .pause:
            musicPlayer.pause()
            playerView.playButton.image = UIImage(named: "play")
        case .volume:
            volumetapped = true
            configureVolumeview()
        }
    }

}
