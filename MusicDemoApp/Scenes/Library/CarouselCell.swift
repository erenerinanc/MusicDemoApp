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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(descriptionLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CGFloat(20)
        imageView.clipsToBounds = true
        playlistNameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        playlistNameLabel.textColor = .white
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.textColor = Colors.secondaryLabel
        
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
            make.top.equalTo(playlistNameLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }
    
    func set(for viewModel: Library.Fetch.ViewModel.Playlist) {
        DispatchQueue.main.async {
            Nuke.loadImage(with: viewModel.artworkURL, into: self.imageView)
            self.playlistNameLabel.text = viewModel.playlistName
            self.descriptionLabel.text = String("\(viewModel.songCount) Songs")
        }
    }
}
