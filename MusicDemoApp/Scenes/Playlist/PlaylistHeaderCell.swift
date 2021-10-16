//
//  PlaylistHeaderCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 4.10.2021.
//

import UIKit
import SnapKit
import Nuke


class PlaylistHeaderCell: UITableViewCell {
    
    static let reuseID = "Header"
    var isPlayTapped = false
    var delegate: HeaderUserInteractionDelegate?
    
    //MARK: -Configure UI Views
    
    private lazy var headerImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        let imageGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(imageSwiped))
        $0.addGestureRecognizer(imageGestureRecognizer)
        $0.isUserInteractionEnabled = true
    }
    lazy var playButtonImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
        $0.layer.cornerRadius = CGFloat(28)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 6.0
        $0.layer.borderColor = Colors.primaryLabel.cgColor
        $0.image = UIImage(named: "play")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseButtonTapped))
        $0.addGestureRecognizer(gestureRecognizer)
        $0.isUserInteractionEnabled = true
    }
    private lazy var backButton = UIImageView().configure {
        $0.image = UIImage(named: "back_button")
        $0.contentMode = .scaleAspectFill
        let backButtonGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        $0.addGestureRecognizer(backButtonGestureRecognizer)
        $0.isUserInteractionEnabled = true
    }
    private lazy var nameLabel = UILabel().configure {
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
    private lazy var descriptionLabel = UILabel().configure {
        $0.textColor = Colors.secondaryLabel
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    
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
        contentView.addSubview(backButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(playButtonImageView)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
   
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).inset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        playButtonImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.bottom).offset(4)
            make.width.equalTo(55)
            make.height.equalTo(55)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc func playPauseButtonTapped(_ gesture: UITapGestureRecognizer) {
        if isPlayTapped {
            delegate?.pauseButtonTapped()
            isPlayTapped = false
            playButtonImageView.image = UIImage(named: "play")
        } else {
            delegate?.playButtonTapped()
            isPlayTapped = true
            playButtonImageView.image = UIImage(named: "pause")
        }
        
    }
    
    @objc func imageSwiped(_ gesture: UISwipeGestureRecognizer) {
        delegate?.imageSwiped()
    }
    
    @objc func backButtonTapped() {
        delegate?.imageSwiped()
    }
    
    private func resizeWidthAndHeight(for urlString: String, width: Int, height: Int) -> String {
        return urlString
            .replacingOccurrences(of: "{w}", with: String(width))
            .replacingOccurrences(of: "{h}", with: String(height))
    }
    
    func set(for viewModel: Playlist.Fetch.ViewModel.CatalogPlaylist) {
        DispatchQueue.main.async {
            let resizedURL = self.resizeWidthAndHeight(for: viewModel.artworkURL, width: 3000, height: 3000)
            Nuke.loadImage(with: resizedURL, into: self.headerImageView)
            self.nameLabel.text = viewModel.name
            self.descriptionLabel.text = viewModel.description
        }
    }


}
