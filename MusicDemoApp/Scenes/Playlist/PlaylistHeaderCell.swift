//
//  PlaylistHeaderCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 4.10.2021.
//

import UIKit
import SnapKit
import Nuke

protocol HeaderUserInteractionDelegate {
    func playButtonTapped()
    func pauseButtonTapped()
    func imageSwiped()
}

class PlaylistHeaderCell: UITableViewCell {
    
    static let reuseID = "Header"
    var isPlayTapped = false
    var delegate: HeaderUserInteractionDelegate?
    
    //MARK: - Configure UI
    
    private lazy var headerImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        let imageGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(imageSwiped))
        $0.addGestureRecognizer(imageGestureRecognizer)
        $0.isUserInteractionEnabled = true
    }
    lazy var playPauseButton = UIButton(type: .system).configure {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
        $0.layer.cornerRadius = CGFloat(28)
        $0.clipsToBounds = true
        $0.layer.borderWidth = 6.0
        $0.layer.borderColor = Colors.primaryLabel.cgColor
        $0.tintColor = Colors.primaryLabel
        $0.setImage(UIImage(named: "play"), for: .normal)
        $0.addTarget(self, action: #selector(playPauseButtonTapped(_:)), for: .touchUpInside)
    }
    private lazy var routeBackButton = UIButton(type: .system).configure {
        $0.tintColor = .white
        $0.setImage(UIImage(named: "back"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
    private lazy var nameLabel = UILabel().configure {
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
    private lazy var descriptionLabel = UILabel().configure {
        $0.textColor = Colors.secondaryLabel
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    //MARK: - Object Lifecycle
    
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
        contentView.addSubview(routeBackButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(playPauseButton)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        routeBackButton.snp.makeConstraints { make in
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
        
        playPauseButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.bottom).offset(4)
            make.width.equalTo(55)
            make.height.equalTo(55)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc func playPauseButtonTapped(_ sender: UIButton) {
        if isPlayTapped {
            delegate?.pauseButtonTapped()
            isPlayTapped = false
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            delegate?.playButtonTapped()
            isPlayTapped = true
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
    }
    
    @objc func imageSwiped(_ gesture: UISwipeGestureRecognizer) {
        delegate?.imageSwiped()
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
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
