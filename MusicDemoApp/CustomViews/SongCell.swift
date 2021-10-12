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
    let hearthIcon = UIView()
    
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
        contentView.addSubview(hearthIcon)
        
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
    }
    
    func set(for viewModel: Library.Fetch.TopSongsViewModel.TopSongs) {
        DispatchQueue.main.async {
            let artworkurl = viewModel.artworkURL.resizeWidhtAndHeight(width: 120, height: 120)
            Nuke.loadImage(with: artworkurl, into: self.musicImageView)
            self.songNameLabel.text = viewModel.songName
            self.subtitleLabel.text = viewModel.artistName
        }
    }
    
    func set(for catalogViewModel: Playlist.Fetch.ViewModel.CatalogPlaylist) {
        DispatchQueue.main.async {
            let artworkurl = catalogViewModel.artworkURL.resizeWidhtAndHeight(width: 120, height: 120)
            Nuke.loadImage(with: artworkurl, into: self.musicImageView)
            self.songNameLabel.text = catalogViewModel.name
            self.subtitleLabel.text = catalogViewModel.description
        }
    }
    func set(for catalogSongViewModel: Playlist.Fetch.ViewModel.CatalogPlaylist.Song) {
        DispatchQueue.main.async {
            let artworkurl = catalogSongViewModel.songArtworkURL.resizeWidhtAndHeight(width: 120, height: 120)
            Nuke.loadImage(with: artworkurl, into: self.musicImageView)
            self.songNameLabel.text = catalogSongViewModel.songName
            self.subtitleLabel.text = catalogSongViewModel.artistName
        }
    }
    
    func set(for searchedSongViewModel: SearchResults.Fetch.SongViewModel.Song) {
        DispatchQueue.main.async {
            let artworkurl = searchedSongViewModel.artworkURL.resizeWidhtAndHeight(width: 120, height: 120)
            Nuke.loadImage(with: artworkurl, into: self.musicImageView)
            self.songNameLabel.text = searchedSongViewModel.name
            self.subtitleLabel.text = searchedSongViewModel.artistName
        }
    }
    
    func set(for searchedArtistViewModel: SearchResults.Fetch.ArtistViewModel.Artist) {
        DispatchQueue.main.async {
            self.songNameLabel.text = searchedArtistViewModel.name
            self.subtitleLabel.text = searchedArtistViewModel.genreName
        }
    }

}
