//
//  LibraryPlaylistCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import SnapKit

class LibraryPlaylistCell: UITableViewCell {
    static let reuseID = "PlaylistCell"
    
    lazy var layout = UICollectionViewFlowLayout().configure {
        $0.itemSize = CGSize(width: 200, height: 260)
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 16
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).configure {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = Colors.background
        $0.register(LibraryCarouselCell.self, forCellWithReuseIdentifier: LibraryCarouselCell.reuseID)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.addSubview(collectionView)
        contentView.backgroundColor = Colors.background
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    
}
