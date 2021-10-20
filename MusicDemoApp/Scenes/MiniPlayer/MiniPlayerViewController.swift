//
//  MiniPlayerViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 18.10.2021.
//

import UIKit
import SnapKit
import Nuke


protocol MiniPlayerDisplayLogic: AnyObject {
    func displayPlaybackState(playbackState: SystemMusicPlayer.PlaybackState)
    func displaySongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation)
}

class MiniPlayerViewController: BaseViewController {
    var interactor: MiniPlayerBusinessLogic?
    var router: (MiniPlayerRoutingLogic & MiniPlayerDataPassing)?
    var isPlaying: Bool = false
    
    //MARK: - Configure UI
    
    lazy var imageContainerView = UIImageView().configure {
        $0.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.95)
    }
    
    lazy var songImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = CGFloat(10)
        $0.clipsToBounds = true
    }
    lazy var songNameLabel = UILabel().configure {
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.text = "Not playing"
        $0.adjustsFontSizeToFitWidth = true
    }
    lazy var playPauseButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "miniplay"), for: .normal)
        $0.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        $0.tintColor = Colors.secondaryLabel
    }
    lazy var skipNextButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "next"), for: .normal)
        $0.addTarget(self, action: #selector(nextSongButtonTapped), for: .touchUpInside)
        $0.tintColor = Colors.secondaryLabel
    }
    lazy var actionBar = UIView().configure {
        $0.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.95)
    }
    
    //MARK: - Object Lifecycle
    
    init(musicPlayer: SystemMusicPlayer) {
        super.init()
        setup(musicPlayer: musicPlayer)
    }
    
    override func loadView() {
        super.loadView()
        layoutUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchPlaybackState()
        interactor?.fetchSongDetail()
    }
    
    //MARK: - Setup
    
    private func setup(musicPlayer: SystemMusicPlayer) {
        let viewController = self
        let interactor = MiniPlayerInteractor(musicPlayer: musicPlayer)
        let presenter = MiniPlayerPresenter()
        let router = MiniPlayerRouter(musicPlayer: musicPlayer)
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func layoutUI() {
        view.backgroundColor = Colors.secondaryBackground
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gestureRecognizer)
        view.addSubview(songNameLabel)
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(songImageView)
        view.addSubview(actionBar)
        actionBar.addSubview(playPauseButton)
        actionBar.addSubview(skipNextButton)
        
        
        imageContainerView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(76)
        }
        
        songImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(60)
        }
        
        songNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(songImageView.snp.trailing).offset(8)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        
        actionBar.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.trailing.equalTo(view.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(84)
        }

        skipNextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.width.height.equalTo(30)
        }
    }
    
    @objc func playPauseButtonTapped() {
        if isPlaying {
            interactor?.pause()
        } else {
            interactor?.play()
        }
    }
    
    @objc func nextSongButtonTapped() {
        interactor?.playNextSong()
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
        router?.routeToMediaPlayer()
    }
    
    func animateLabel() {

        UIView.animate(withDuration: 10.0, delay: 0.0, options: [.repeat, .curveEaseInOut], animations: {
            self.songNameLabel.transform = CGAffineTransform(translationX: self.songNameLabel.bounds.origin.x + 200, y: self.songNameLabel.bounds.origin.y)
        }, completion: nil)
        
        UIView.animate(withDuration: 10.0, delay: 0.0, options: [.repeat, .curveEaseInOut]) {
            self.songNameLabel.transform = CGAffineTransform(translationX: self.songNameLabel.bounds.origin.x - 300, y: self.songNameLabel.bounds.origin.y)
        }

    }
    
    func stopAnimating() {
        UIView.animate(withDuration: 0.0, delay: 0, options: []) {
            self.songNameLabel.transform = .identity
        }
    }
}

//MARK: - Display Logic

extension MiniPlayerViewController: MiniPlayerDisplayLogic {
    func displayPlaybackState(playbackState: SystemMusicPlayer.PlaybackState) {
        let isPlaying = playbackState.status == .playing
        self.isPlaying = isPlaying
        playPauseButton.setImage(UIImage(named: isPlaying ? "minipause" : "miniplay"), for: .normal)
        
        if isPlaying {
            animateLabel()
        } else {
            stopAnimating()
        }
    }
    
    func displaySongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation) {
        Nuke.loadImage(with: songInfo.iconArtworkURL, into: songImageView)
        songNameLabel.text = songInfo.songName
    }
}
