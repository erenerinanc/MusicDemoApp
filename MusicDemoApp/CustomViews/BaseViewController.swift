//
//  BaseViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 27.09.2021.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
