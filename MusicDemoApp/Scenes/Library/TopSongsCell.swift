//
//  TopSongsCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import SnapKit
import Nuke

class TopSongsCell: UITableViewCell {
    static let reuseID = "FavoriteSongCell"
    
    let musicImageView = UIImageView()
    let songNameLabel = UILabel()
    let subtitleLabel = UILabel()
    let hearthIcon = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = Colors.background
        contentView.addSubview(musicImageView)
        contentView.addSubview(songNameLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(hearthIcon)
        
       
        musicImageView.contentMode = .scaleAspectFill
        musicImageView.layer.cornerRadius = CGFloat(10)
        musicImageView.clipsToBounds = true
        songNameLabel.textColor = .white
        songNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = Colors.secondaryLabel
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        musicImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(8)
            make.bottom.equalTo(self.snp.bottom).inset(8)
            make.leading.equalTo(self.snp.leading).inset(24)
            make.width.equalTo(60)
        }
        
        songNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(musicImageView.snp.trailing).offset(8)
            make.top.equalTo(self.snp.top).inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(musicImageView.snp.trailing).offset(8)
            make.top.equalTo(songNameLabel.snp.bottom).offset(4)
            
        }
    }
    
    func set(for viewModel: Library.Fetch.TopSongsViewModel.TopSongs) {
        DispatchQueue.main.async {
            let artworkurl = viewModel.artworkURL.replacingOccurrences(of: "{w}", with: "60").replacingOccurrences(of: "{h}", with: "60")
            Nuke.loadImage(with: artworkurl, into: self.musicImageView)
            self.songNameLabel.text = viewModel.songName
            self.subtitleLabel.text = viewModel.artistName
        }
    }

}
