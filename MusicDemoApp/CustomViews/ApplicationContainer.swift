//
//  ApplicationContainer.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 18.10.2021.
//

import UIKit

class ApplicationContainer: BaseViewController {
    let musicPlayer: SystemMusicPlayer
    let navController: UINavigationController
    init(musicPlayer: SystemMusicPlayer, rootViewController: UIViewController) {
        self.musicPlayer = musicPlayer
        self.navController = UINavigationController(rootViewController: rootViewController)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navController.navigationBar.tintColor = .white
        navController.navigationBar.barTintColor = Colors.background
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barStyle = .blackTranslucent
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerStateDidChange(_:)),
                                               name: musicPlayer.playerStateDidChange,
                                               object: nil)
        
        updateMiniPlayerAppearance()
    }
    
    @objc private func playerStateDidChange(_ notification: Notification) {
        updateMiniPlayerAppearance()
    }
    
    private func updateMiniPlayerAppearance() {
        if musicPlayer.playingSongInformation == nil {
            miniPlayer.view.isHidden = true
            additionalSafeAreaInsets = .init()
        } else {
            miniPlayer.view.isHidden = false
            additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 74, right: 0)
        }
    }
    
    lazy var miniPlayer = MiniPlayerViewController(musicPlayer: musicPlayer).configure {
        $0.view.backgroundColor = Colors.secondaryBackground.withAlphaComponent(0.95)
        $0.view.clipsToBounds = true
    }
    
    override func loadView() {
        view = UIView()
        
        addChild(navController)
        view.addSubview(navController.view)
        navController.view.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
        navController.didMove(toParent: self)
        
        addChild(miniPlayer)
        view.addSubview(miniPlayer.view)
        miniPlayer.view.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(74)
        }
    }
}
