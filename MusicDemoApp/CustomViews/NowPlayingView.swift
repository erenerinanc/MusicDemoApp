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
    }
    let column2 = UIView().configure {
        $0.backgroundColor = .white
    }
    let column3 = UIView().configure {
        $0.backgroundColor = .white
    }
    let column4 = UIView().configure {
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
        addSubview(column1)
        addSubview(column2)
        addSubview(column3)
        addSubview(column4)
        
        column1.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(2)
            make.height.equalTo(10)
        }
        
        column2.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(4)
            make.width.equalTo(2)
            make.height.equalTo(10)
        }
        
        column3.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.width.equalTo(2)
            make.height.equalTo(10)
        }
        
        column4.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.width.equalTo(2)
            make.height.equalTo(10)
        }
     
    }
    
    func animate() {
        var yValue = CGFloat(0)
        column1.transform = CGAffineTransform(scaleX: 1, y: yValue)
        column2.transform = CGAffineTransform(scaleX: 1, y: yValue)
        column3.transform = CGAffineTransform(scaleX: 1, y: yValue)
        column4.transform = CGAffineTransform(scaleX: 1, y: yValue)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: []) {
                self.column2.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: []) {
                self.column2.transform = CGAffineTransform(scaleX: 0, y: 1)
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: []) {
                self.column3.transform = CGAffineTransform(scaleX: 0, y: 1)
            }
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: []) {
                self.column4.transform = CGAffineTransform(scaleX: 0, y: 1)
            }
        }
    }
}
