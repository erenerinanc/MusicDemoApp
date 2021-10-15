//
//  NowPlayingView.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 14.10.2021.
//

import UIKit
import SnapKit

class NowPlayingView: UIView {
    var xCoordinate: Double = 0
    let column = UIView().configure {
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        for _ in 0...3 {
            addSubview(column)
            column.frame = CGRect(x: xCoordinate, y: 0, width: 2, height: 10)
            xCoordinate += 2
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: []) {
            var height = self.column.frame.height
            if height == 0 {
                while height <= 10 {
                    height += 2
                }
            }
            
            if height == 10 {
                while height >= 0 {
                    height -= 2
                }
            }
        }

    }
}
