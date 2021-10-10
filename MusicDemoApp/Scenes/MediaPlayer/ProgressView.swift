//
//  ProgressStackView.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 7.10.2021.
//

import UIKit
import SnapKit
import AudioToolbox

class ProgressView: UIView{
    let progressView = UIProgressView(progressViewStyle: .default)
    let durationLabel = UILabel()
    let songDurationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(progressView)
        addSubview(durationLabel)
        addSubview(songDurationLabel)
        backgroundColor = Colors.background
        
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        progressView.tintColor = Colors.primaryLabel
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
        
        durationLabel.textColor = Colors.secondaryLabel
        
        songDurationLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
        }
        
        songDurationLabel.textColor = Colors.secondaryBackground
    }
}
