//
//  PlayerstackView.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 4.10.2021.
//

import UIKit
import SnapKit

class PlayerView: UIView {
    let replayButton = UIImageView()
    let firstButton = UIImageView()
    let playButton = UIImageView()
    let lastButton = UIImageView()
    let volumeButton = UIImageView()
    var delegate: PlayerViewDelegate?
    var isNowPlaying = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePlayerView()
        configureButtonActions()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePlayerView() {
        let items = [replayButton,firstButton,playButton,lastButton,volumeButton]
        items.forEach { addSubview($0) }
        backgroundColor = Colors.background

        replayButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(replayButton.snp.width)
        }
        
        firstButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(replayButton.snp.trailing).offset(32)
            make.width.equalTo(30)
            make.height.equalTo(firstButton.snp.width)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(firstButton.snp.trailing).offset(32)
            make.width.equalTo(55)
            make.height.equalTo(playButton.snp.width)
        }
        
        lastButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playButton.snp.trailing).offset(32)
            make.width.equalTo(30)
            make.height.equalTo(lastButton.snp.width)
        }
        
        volumeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(lastButton.snp.trailing).offset(32)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        replayButton.image = UIImage(named: "repeat")
        firstButton.image = UIImage(named: "first")
        playButton.image = UIImage(named: "play")
        lastButton.image = UIImage(named: "last")
        volumeButton.image = UIImage(named: "audio_on")
        
        playButton.contentMode = .scaleAspectFill
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = CGFloat(28)
        playButton.clipsToBounds = true
        playButton.layer.borderWidth = 6.0
        playButton.layer.borderColor = Colors.primaryLabel.cgColor
      
    }
    
    private func configureButtonActions() {
        let gestureRecognizerForReplayButton = UITapGestureRecognizer(target: self, action: #selector(replayButtonTapped))
        replayButton.addGestureRecognizer(gestureRecognizerForReplayButton)
        replayButton.isUserInteractionEnabled = true
        
        let gestureRecognizerForFirstButton = UITapGestureRecognizer(target: self, action: #selector(firstButtonTapped))
        firstButton.addGestureRecognizer(gestureRecognizerForFirstButton)
        firstButton.isUserInteractionEnabled = true
        
        let gestureRecognizerForPlayButton = UITapGestureRecognizer(target: self, action: #selector(playPauseButtonTapped))
        playButton.addGestureRecognizer(gestureRecognizerForPlayButton)
        playButton.isUserInteractionEnabled = true
        
        let gestureRecognizerForLastButton = UITapGestureRecognizer(target: self, action: #selector(lastButtonTapped))
        lastButton.addGestureRecognizer(gestureRecognizerForLastButton)
        lastButton.isUserInteractionEnabled = true
        
        let gestureRecognizerForVolumeButton = UITapGestureRecognizer(target: self, action: #selector(volumeButtonTapped))
        volumeButton.addGestureRecognizer(gestureRecognizerForVolumeButton)
        volumeButton.isUserInteractionEnabled = true
    }
    
    @objc func replayButtonTapped(_ gesture: UITapGestureRecognizer) {
        print("Replay tapped")
        delegate?.buttonTapped(with: .replay)
    }
    
    @objc func firstButtonTapped(_ gesture: UITapGestureRecognizer) {
        print("Previous tapped")
        delegate?.buttonTapped(with: .previous)
    }
    
    @objc func playPauseButtonTapped(_ gesture: UITapGestureRecognizer) {
        print("Play tapped")
        guard let delegate = delegate else { return }
        if isNowPlaying {
            delegate.buttonTapped(with: .pause)
            isNowPlaying = false
        } else {
            delegate.buttonTapped(with: .play)
            isNowPlaying = true
        }
        
    }
    
    @objc func lastButtonTapped(_ gesture: UITapGestureRecognizer) {
        print("Next Tapped")
        delegate?.buttonTapped(with: .next)
    }
    
    @objc func volumeButtonTapped(_ gesture: UITapGestureRecognizer) {
        print("Volume tapped")
        delegate?.buttonTapped(with: .volume)
    }
    
}
