//
//  SongCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import SnapKit
import Nuke

class SongCell: UITableViewCell {
    static let reuseID = "SongCell"
    
    let musicImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = CGFloat(10)
        $0.clipsToBounds = true
    }
    let songNameLabel = UILabel().configure {
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    let subtitleLabel = UILabel().configure {
        $0.textColor = Colors.secondaryLabel
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    let nowPlayingShade = UIView().configure {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    let nowPlayingView = NowPlayingView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutCellUI() {
        backgroundColor = Colors.background
        contentView.addSubview(musicImageView)
        contentView.addSubview(songNameLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(nowPlayingView)
        
        musicImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(8)
            make.bottom.equalTo(self.snp.bottom).inset(8)
            make.leading.equalTo(self.snp.leading).inset(16)
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
        
        nowPlayingShade.isHidden = true
        musicImageView.addSubview(nowPlayingShade)
        nowPlayingShade.snp.makeConstraints { $0.directionalEdges.equalTo(musicImageView) }
        
        nowPlayingShade.addSubview(nowPlayingView)
        nowPlayingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(8)
        }
    }
    
    private func resizeWidhtAndHeight(for urlString: String, width: Int, height: Int) -> String {
        return urlString
            .replacingOccurrences(of: "{w}", with: String(width))
            .replacingOccurrences(of: "{h}", with: String(height))
    }
    
    func set(for viewModel: Library.Fetch.TopSongsViewModel.TopSongs, isPlaying: Bool) {
        let resizedURL = resizeWidhtAndHeight(for: viewModel.artworkURL, width: 120, height: 120)
        Nuke.loadImage(with: resizedURL, into: musicImageView)
        songNameLabel.text = viewModel.songName
        subtitleLabel.text = viewModel.artistName
        
        if isPlaying {
            nowPlayingShade.isHidden = false
        } else {
            nowPlayingShade.isHidden = true
        }
    }
    
    func set(for catalogViewModel: Playlist.Fetch.ViewModel.CatalogPlaylist) {
        let resizedURL = resizeWidhtAndHeight(for: catalogViewModel.artworkURL, width: 120, height: 120)
        Nuke.loadImage(with: resizedURL, into: musicImageView)
        songNameLabel.text = catalogViewModel.name
        subtitleLabel.text = catalogViewModel.description
    }
    func set(for catalogSongViewModel: Playlist.Fetch.ViewModel.CatalogPlaylist.Song) {
        let resizedURL = resizeWidhtAndHeight(for: catalogSongViewModel.songArtworkURL, width: 120, height: 120)
        Nuke.loadImage(with: resizedURL, into: musicImageView)
        songNameLabel.text = catalogSongViewModel.songName
        subtitleLabel.text = catalogSongViewModel.artistName
    }
    
    func set(for searchedSongViewModel: SearchResults.Fetch.SongViewModel.Song) {
        let resizedURL = resizeWidhtAndHeight(for: searchedSongViewModel.artworkURL, width: 120, height: 120)
        Nuke.loadImage(with: resizedURL, into: musicImageView)
        songNameLabel.text = searchedSongViewModel.name
        subtitleLabel.text = "Song ・ \(searchedSongViewModel.artistName)"
    }
    
    func set(for searchedArtistViewModel: SearchResults.Fetch.ArtistViewModel.Artist) {
        songNameLabel.text = searchedArtistViewModel.name
        subtitleLabel.text = "Artist"
    }

}
