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
    func displayPlaybackState(viewModel: MediaPlayer.Fetch.PlaybackViewModel)
}

final class MediaPlayerViewController: BaseViewController {
    
    var interactor: MediaPlayerBusinessLogic?
    var router: (MediaPlayerRoutingLogic & MediaPlayerDataPassing)?
    
    private var songID: String?
    private var presentIndex: Int = 0
    private var volumetapped: Bool = false
    private var progressTimer: Timer?
    
    //MARK: -Configure UI Views
    
    private lazy var songImageview = UIImageView().configure {
        $0.backgroundColor = Colors.background
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = CGFloat(150)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 3.0
        $0.layer.borderColor = Colors.primaryLabel.cgColor
    }
    private lazy var swipeView = UIView().configure {
        $0.backgroundColor = Colors.secondaryBackground
        $0.layer.cornerRadius = CGFloat(5)
    }
    private lazy var songNameLabel = UILabel().configure {
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    private lazy var descriptionLabel = UILabel().configure {
        $0.textColor = Colors.secondaryLabel
    }
    private lazy var contentView = UIView().configure {
        $0.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.7)
        $0.layer.cornerRadius = CGFloat(30)
    }
    private lazy var volumeView = MPVolumeView().configure {
        $0.tintColor = Colors.secondaryLabel
        $0.sizeToFit()
    }
    private lazy var progressView = MediaPlayerProgressView()
    private lazy var playerView = MediaPlayerButtonsView()
    
    // MARK: -Object lifecycle
    
    override init() {
        super.init()
        setup()
    }
    
    override func loadView() {
        super.loadView()
        layoutUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.playInitialSong()
    }
    
    // MARK: -Setup
    
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
    
    //MARK: -Layout UI
 
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
    
        songImageview.snp.makeConstraints { make in
            make.top.equalTo(swipeView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.height.equalTo(songImageview.snp.width)
        }
        
        songNameLabel.snp.makeConstraints { make in
            make.top.equalTo(songImageview.snp.bottom).offset(16)
            make.centerX.equalTo(songImageview.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(16)
            make.centerX.equalTo(songNameLabel.snp.centerX)
        }
        
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
    }
    
    private func configureVolumeview() {
        view.addSubview(contentView)
        contentView.addSubview(volumeView)
  
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

//MARK: -Display Logic

extension MediaPlayerViewController: MediaPlayerDisplayLogic {
    func displaySongDetail(viewModel: MediaPlayer.Fetch.ViewModel) {
        if let artworkURL = viewModel.artworkURL {
            Nuke.loadImage(with: artworkURL, into: songImageview)
        }
        
        songNameLabel.text = viewModel.songName
        descriptionLabel.text = viewModel.artistName
    }
    
    func displayPlaybackState(viewModel: MediaPlayer.Fetch.PlaybackViewModel) {
        let isPlaying = viewModel.status == .playing
        progressView.configure(playbackTime: viewModel.currentTime, songDuration: viewModel.songDuration)
        
        playerView.playButton.image = UIImage(named: isPlaying ? "pause" : "play")
        
        if isPlaying {
            progressTimer?.invalidate()
            progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak interactor] _ in
                interactor?.fetchPlaybackState()
            })
        } else {
            progressTimer?.invalidate()
            progressTimer = nil
        }
    }
}

//MARK: -PlayerView Delegate

extension MediaPlayerViewController: MediaPlayerButtonsViewDelegate {
    func buttonTapped(with button: PlayerButton) {
        switch button {
        case .replay:
            break
        case .previous:
            interactor?.playPreviousSong()
        case .next:
            interactor?.playNextSong()
        case .play:
            interactor?.play()
        case .pause:
            interactor?.pause()
        case .volume:
            volumetapped = true
            configureVolumeview()
        }
    }

}
