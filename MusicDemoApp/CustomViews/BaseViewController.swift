//
//  BaseViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 19.10.2021.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    private lazy var containerView = UIView().configure {
        $0.backgroundColor = Colors.secondaryLabel
        $0.alpha = 0
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showLoadingView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        containerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }

        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
        }
    }

}
