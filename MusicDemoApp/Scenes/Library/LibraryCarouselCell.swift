//
//  LibraryCarouselCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import Nuke
import SnapKit

class LibraryCarouselCell: UICollectionViewCell {
    static let reuseID = "CarouselCell"
    
    let imageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = CGFloat(35)
        $0.clipsToBounds = true
    }
    let playlistNameLabel = UILabel().configure {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.textColor = .white
    }
    let descriptionLabel = UILabel().configure {
        $0.textColor = Colors.secondaryLabel
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutCellUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(descriptionLabel)
        
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
