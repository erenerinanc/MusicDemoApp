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
    case shuffle
    case previous
    case next
    case playPause
    case volume
}

final class MediaPlayerViewController: BaseViewController {

    
    private var volumetapped: Bool = false
    private var progressTimer: Timer?
    var musicPlayer: SystemMusicPlayer?
    var isPlaying: Bool = false
    
    //MARK: - Configure UI
    
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
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
    }
    private lazy var artistNameLabel = UILabel().configure {
        $0.textColor = Colors.secondaryLabel
    }
    private lazy var contentView = UIView().configure {
        $0.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.7)
        $0.layer.cornerRadius = CGFloat(30)
    }
    private lazy var volumeView = MPVolumeView().configure {
        $0.showsVolumeSlider = true
        $0.tintColor = Colors.secondaryLabel
        $0.sizeToFit()
    }
    private lazy var progressView = MediaPlayerProgressView()
    private lazy var playerView = MediaPlayerActionBar()

    
    // MARK: - Object lifecycle
    
    init(musicPlayer: SystemMusicPlayer) {
        super.init()
        self.musicPlayer = musicPlayer
        NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerStateDidChange(_:)), name: musicPlayer.playerStateDidChange, object: musicPlayer)
    }

    override func loadView() {
        super.loadView()
        layoutUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNowPlayingSong()
    }


    //MARK: - Layout UI
 
    private func layoutUI() {
        view.backgroundColor = Colors.background
        view.addSubview(swipeView)
        view.addSubview(songImageview)
        view.addSubview(songNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(progressView)
        view.addSubview(playerView)
        playerView.delegate = self
        
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
            make.leading.trailing.equalToSuperview().inset(8)
    
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(16)
            make.centerX.equalTo(songNameLabel.snp.centerX)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    @objc func  musicPlayerStateDidChange(_ notification: Notification) {
        fetchNowPlayingSong()
    }
    
    func fetchNowPlayingSong() {
        guard let nowPlayingSong = musicPlayer?.playingSongInformation else { return }
        guard let playbackState = musicPlayer?.playbackState else { return }
        guard let isShuffled = musicPlayer?.isShuffled else { return }
        isPlaying = musicPlayer?.playbackState?.status == .playing
        
        Nuke.loadImage(with: nowPlayingSong.artworkURL, into: self.songImageview)
        songNameLabel.text = nowPlayingSong.songName
        artistNameLabel.text = nowPlayingSong.artistName
        progressView.configure(playbackTime: playbackState.currentTime, songDuration: playbackState.songDuration)
        playerView.playButton.setImage(UIImage(named: isPlaying ? "pause" : "play"), for: .normal)
        
        if isShuffled {
            playerView.shuffleButton.tintColor = Colors.primaryLabel
        } else {
            playerView.shuffleButton.tintColor = Colors.secondaryLabel
        }
        
        if isPlaying {
            progressTimer?.invalidate()
            progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                self?.fetchNowPlayingSong()
            })
        } else {
            progressTimer?.invalidate()
            progressTimer = nil
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


//MARK: - PlayerView Delegate

extension MediaPlayerViewController: MediaPlayerButtonsViewDelegate {
    func buttonTapped(with button: PlayerButton) {
        switch button {
        case .shuffle:
            musicPlayer?.shuffle()
        case .previous:
            musicPlayer?.playPreviousSong()
        case .next:
            musicPlayer?.playNextSong()
        case .playPause:
            if isPlaying {
                musicPlayer?.pause()
            } else {
                musicPlayer?.play()
            }
        case .volume:
            volumetapped = true
            configureVolumeview()
        }
    }

}
