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
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().offset(8)
            make.height.equalToSuperview().inset(24)
        }
        
        playlistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    
    }
    
    private func resizeWidthAndHeight(for urlString: String, width: Int, height: Int) -> String {
        return urlString
            .replacingOccurrences(of: "{w}", with: String(width))
            .replacingOccurrences(of: "{h}", with: String(height))
    
    }
    
    func set(for viewModel: Library.Fetch.PlaylistViewModel.Playlist) {
        DispatchQueue.main.async {
            let resizedURL = self.resizeWidthAndHeight(for: viewModel.artworkURL, width: 300, height: 300)
            Nuke.loadImage(with: resizedURL, into: self.imageView)
            self.playlistNameLabel.text = viewModel.playlistName
        }
    }

}
