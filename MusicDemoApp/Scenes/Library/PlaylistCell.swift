//
//  PlaylistCell.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 22.09.2021.
//

import UIKit
import SnapKit

class PlaylistCell: UITableViewCell {
    static let reuseID = "PlaylistCell"
    
    lazy var layout = UICollectionViewFlowLayout().configure {
        $0.itemSize = CGSize(width: 200, height: 260)
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 16
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layoutUI() {
        contentView.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.background
        collectionView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseID)
    }
    
    
}
