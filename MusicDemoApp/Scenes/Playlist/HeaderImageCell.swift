//
//  HeaderImageCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 4.10.2021.
//

import UIKit
import SnapKit
import Nuke


class HeaderImageCell: UITableViewCell {
    static let reuseID = "Header"
    let headerImageView = UIImageView()
    let playButtonImage = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    var delegate: PlayButtonDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.backgroundColor = Colors.background
        contentView.addSubview(headerImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(playButtonImage)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).inset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        playButtonImage.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.bottom).offset(4)
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.trailing.equalToSuperview().inset(24)
        }
        
        headerImageView.contentMode = .scaleAspectFill
        nameLabel.textColor = .white
        descriptionLabel.textColor = Colors.secondaryLabel
        nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        playButtonImage.image = UIImage(named: "circled_play")
        playButtonImage.contentMode = .scaleAspectFill
        playButtonImage.backgroundColor = .white
        playButtonImage.layer.cornerRadius = CGFloat(30)
        playButtonImage.clipsToBounds = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func buttonTapped(_ gesture: UITapGestureRecognizer) {
        print("Button tapped")
        delegate?.playButtonTapped()
    }
    
    func set(for viewModel: Playlist.Fetch.ViewModel.CatalogPlaylist) {
        DispatchQueue.main.async {
            let artworkURL = viewModel.artworkURL.replacingOccurrences(of: "{w}", with: "3000").replacingOccurrences(of: "{h}", with: "3000")
            Nuke.loadImage(with: artworkURL, into: self.headerImageView)
            self.nameLabel.text = viewModel.name
            self.descriptionLabel.text = viewModel.description
        }
    }


}
