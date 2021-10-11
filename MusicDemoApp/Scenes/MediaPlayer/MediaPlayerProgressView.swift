//
//  ProgressStackView.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 7.10.2021.
//

import UIKit
import SnapKit
import AudioToolbox

class MediaPlayerProgressView: UIView{
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let songDurationLabel = UILabel()
    private let playbackTimeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var timeFormatter = DateComponentsFormatter().configure {
        $0.allowedUnits = [.minute, .second]
        $0.zeroFormattingBehavior = .pad
        $0.unitsStyle = .positional
    }

    public func configure(playbackTime: TimeInterval, songDuration: TimeInterval) {
        let progress = songDuration == 0 ? 0 : Float(playbackTime / songDuration)
        progressView.setProgress(progress, animated: true)
        
        playbackTimeLabel.text = timeFormatter.string(from: playbackTime)
        songDurationLabel.text = timeFormatter.string(from: songDuration)
    }
    
    private func setupViews() {
        addSubview(progressView)
        addSubview(songDurationLabel)
        addSubview(playbackTimeLabel)
        backgroundColor = Colors.background
        
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        progressView.tintColor = Colors.primaryLabel
        
        songDurationLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
        }
        
        songDurationLabel.textColor = Colors.tertiaryLabel
        songDurationLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        playbackTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
        }
        
        playbackTimeLabel.textColor = Colors.secondaryLabel
        playbackTimeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
}
