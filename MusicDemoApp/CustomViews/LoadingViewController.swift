//
//  LoadingViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 19.10.2021.
//

import UIKit
import SnapKit

class LoadingViewController: UIViewController {
    let indicator = UIActivityIndicatorView()
    var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicator)
        indicator.snp.makeConstraints { $0.center.equalToSuperview() }
        if isLoading {
            indicator.isHidden = false
        } else {
            indicator.isHidden = true
        }
    }

}
