//
//  MusicManager.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 19.10.2021.
//

import Foundation


class MusicManager {
    static let shared = MusicManager()
    private init() {}
    
    var storeFrontID: String?
    var musicPlayer: SystemMusicPlayer?
    var musicAPI: AppleMusicAPI?
    
  
}
