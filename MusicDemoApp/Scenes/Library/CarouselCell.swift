//
//  CarouselCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import Nuke
import SnapKit

class CarouselCell: UICollectionViewCell {
    static let reuseID = "CarouselCell"
    
    let imageView = UIImageView()
    let playlistNameLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(descriptionLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CGFloat(35)
        imageView.clipsToBounds = true
        playlistNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        playlistNameLabel.textColor = .white
        descriptionLabel.textColor = Colors.secondaryLabel
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(8)
            make.height.equalToSuperview().inset(30)
        }
        
        playlistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(playlistNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(playlistNameLabel.snp.leading)
        }
    
    }
    
    func set(for viewModel: Library.Fetch.PlaylistViewModel.Playlist) {
        DispatchQueue.main.async {
            let artworkurl = viewModel.artworkURL.resizeWidhtAndHeight(width: 300, height: 300)
            Nuke.loadImage(with: artworkurl, into: self.imageView)
            self.playlistNameLabel.text = viewModel.playlistName
            self.descriptionLabel.text = "\(viewModel.songCount) Songs"
        }
    }
}
