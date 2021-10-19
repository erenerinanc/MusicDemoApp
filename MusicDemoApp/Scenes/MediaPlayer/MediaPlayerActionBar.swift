//
//  MediaPlayerActionBar.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 4.10.2021.
//

import UIKit
import SnapKit

protocol MediaPlayerButtonsViewDelegate {
    func buttonTapped(with button: PlayerButton)
}

class MediaPlayerActionBar: UIView {
    let shuffleButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "shuffle"), for: .normal)
        $0.tintColor = Colors.secondaryLabel
        $0.addTarget(self, action: #selector(shuffleButtonTapped(_:)), for: .touchUpInside)
    }
    let skipPreviousButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "previous"), for: .normal)
        $0.tintColor = Colors.secondaryLabel
        $0.addTarget(self, action: #selector(previousButtonTapped(_:)), for: .touchUpInside)
    }
    let playButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
        $0.layer.cornerRadius = CGFloat(28)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 6.0
        $0.layer.borderColor = Colors.primaryLabel.cgColor
        $0.setImage(UIImage(named: "play"), for: .normal)
        $0.tintColor = Colors.primaryLabel
        $0.addTarget(self, action: #selector(playPauseButtonTapped(_:)), for: .touchUpInside)
    }
    let skipNextButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = Colors.secondaryLabel
        $0.setImage(UIImage(named: "next"), for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
    let volumeButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = Colors.secondaryLabel
        $0.setImage(UIImage(named: "volume"), for: .normal)
        $0.addTarget(self, action: #selector(volumeButtonTapped(_:)), for: .touchUpInside)
    }
    var delegate: MediaPlayerButtonsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePlayerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePlayerView() {
        let items = [shuffleButton,skipPreviousButton,playButton,skipNextButton,volumeButton]
        items.forEach { addSubview($0) }
        backgroundColor = Colors.background

        shuffleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(shuffleButton.snp.width)
        }
        
        skipPreviousButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(shuffleButton.snp.trailing).offset(32)
            make.width.equalTo(30)
            make.height.equalTo(skipPreviousButton.snp.width)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(skipPreviousButton.snp.trailing).offset(32)
            make.width.equalTo(55)
            make.height.equalTo(playButton.snp.width)
        }
        
        skipNextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playButton.snp.trailing).offset(32)
            make.width.equalTo(30)
            make.height.equalTo(skipNextButton.snp.width)
        }
        
        volumeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(skipNextButton.snp.trailing).offset(32)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
      
    }
    
    
    @objc func shuffleButtonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(with: .shuffle)
    }
    
    @objc func previousButtonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(with: .previous)
    }
    
    @objc func playPauseButtonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(with: .playPause)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(with: .next)
    }
    
    @objc func volumeButtonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(with: .volume)
    }
    
}
