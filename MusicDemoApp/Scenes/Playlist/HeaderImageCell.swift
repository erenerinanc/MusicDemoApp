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
    var isButtonTapped = false
    var playButtonImage = UIImageView() 
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    var delegate: HeaderUserInteractionDelegate?
    
    
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
            make.width.equalTo(55)
            make.height.equalTo(55)
            make.trailing.equalToSuperview().inset(24)
        }
        
        headerImageView.contentMode = .scaleAspectFill
        nameLabel.textColor = .white
        descriptionLabel.textColor = Colors.secondaryLabel
        nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        let imageGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(imageSwiped))
        headerImageView.addGestureRecognizer(imageGestureRecognizer)
        headerImageView.isUserInteractionEnabled = true

        playButtonImage.contentMode = .scaleAspectFill
        playButtonImage.backgroundColor = .white
        playButtonImage.layer.cornerRadius = CGFloat(28)
        playButtonImage.clipsToBounds = true
        playButtonImage.layer.borderWidth = 6.0
        playButtonImage.layer.borderColor = Colors.primaryLabel.cgColor
        playButtonImage.image = UIImage(named: "play")
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        playButtonImage.addGestureRecognizer(gestureRecognizer)
        playButtonImage.isUserInteractionEnabled = true
    }
    
    @objc func buttonTapped(_ gesture: UITapGestureRecognizer) {
        print("Button tapped")
        if isButtonTapped {
            delegate?.pauseButtonTapped()
        } else {
            delegate?.playButtonTapped()
        }
        
    }
    
    @objc func imageSwiped(_ gesture: UISwipeGestureRecognizer) {
        print("Image swiped")
        delegate?.imageSwiped()
        
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
