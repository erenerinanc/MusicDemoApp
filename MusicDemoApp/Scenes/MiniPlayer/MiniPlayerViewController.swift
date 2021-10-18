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
    var isPlayTapped: Bool = false
    
    //MARK: - Configure UI
    
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
    lazy var playPauseImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "miniplay")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseButtonTapped))
        $0.addGestureRecognizer(gestureRecognizer)
        $0.isUserInteractionEnabled = true
    }
    lazy var nextSongImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "last")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextSongButtonTapped))
        $0.addGestureRecognizer(gestureRecognizer)
        $0.isUserInteractionEnabled = true
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
        view.addSubview(songImageView)
        view.addSubview(songNameLabel)
        view.addSubview(playPauseImageView)
        view.addSubview(nextSongImageView)
        
        songImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(60)
        }
        
        songNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(songImageView.snp.trailing).offset(8)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        playPauseImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.width.height.equalTo(25)
            make.leading.equalTo(songNameLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(72)
        }
        
        nextSongImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.trailing.equalToSuperview().inset(24)
            make.width.height.equalTo(28)
        }
    }
    
    @objc func playPauseButtonTapped(_ gesture: UITapGestureRecognizer) {
        if isPlayTapped {
            print("Pause tapped")
            playPauseImageView.image = UIImage(named: "miniplay")
            interactor?.play()
            isPlayTapped = false
        } else {
            print("Play tapped")
            playPauseImageView.image = UIImage(named: "minipause")
            interactor?.pause()
            isPlayTapped = true
        }
    }
    
    @objc func nextSongButtonTapped(_ gesture: UITapGestureRecognizer) {
        interactor?.playNextSong()
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
        router?.routeToMediaPlayer()
    }
}

//MARK: - Display Logic

extension MiniPlayerViewController: MiniPlayerDisplayLogic {
    func displayPlaybackState(playbackState: SystemMusicPlayer.PlaybackState) {
        let isPlaying = playbackState.status == .playing
        playPauseImageView.image = UIImage(named: isPlaying ? "minipause" : "miniplay")
    }
    
    func displaySongDetail(songInfo: SystemMusicPlayer.PlayingSongInformation) {
        Nuke.loadImage(with: songInfo.iconArtworkURL, into: songImageView)
        songNameLabel.text = songInfo.songName
    }
}
