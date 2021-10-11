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
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).configure {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = Colors.background
        $0.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseID)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
