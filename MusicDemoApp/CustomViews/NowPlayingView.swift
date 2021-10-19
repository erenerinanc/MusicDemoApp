//
//  NowPlayingView.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 14.10.2021.
//

import UIKit
import SnapKit

class NowPlayingView: UIView {
    let column1 = UIView().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 1
    }
    let column2 = UIView().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 1
    }
    let column3 = UIView().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 1
    }
    let column4 = UIView().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 1
    }
    
    var columns: [UIView] { [column1, column2, column3, column4] }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        animate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 21, height: 14)
    }
    
    private func layoutUI() {
        addSubview(column1)
        addSubview(column2)
        addSubview(column3)
        addSubview(column4)
        
        let bottomAnchor = CGPoint(x: 0.5, y: 1)
        column1.layer.anchorPoint = bottomAnchor
        column2.layer.anchorPoint = bottomAnchor
        column3.layer.anchorPoint = bottomAnchor
        column4.layer.anchorPoint = bottomAnchor
        
        column1.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(3)
        }
        
        column2.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(6)
            make.width.equalTo(3)
        }
        
        column3.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.width.equalTo(3)
        }
        
        column4.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(18)
            make.width.equalTo(3)
        }
     
    }
    
    private func animate() {
        columns.forEach { $0.layer.removeAnimation(forKey: "jump") }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        CATransaction.setCompletionBlock {
            [weak self] in
            self?.animate()
        }
        
        for column in columns {
            let randomYScale = CGFloat.random(in: 0.5...1)
            let minYScale = CGFloat.random(in: 0.05...0.35)
            let animation = CABasicAnimation(keyPath: "transform")
            
            let newTransform = CATransform3DMakeScale(1, randomYScale, 1)
            animation.fromValue = CATransform3DMakeScale(1, minYScale, 1)
            animation.toValue = newTransform
            animation.autoreverses = true
            animation.duration = 0.5
            animation.isAdditive = true
            
            column.layer.transform = newTransform
            column.layer.add(animation, forKey: "jump")
        }
        
        CATransaction.commit()
    }
}
