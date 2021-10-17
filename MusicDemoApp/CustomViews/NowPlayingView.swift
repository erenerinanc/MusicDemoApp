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
    
    #warning("Do animations")
}
