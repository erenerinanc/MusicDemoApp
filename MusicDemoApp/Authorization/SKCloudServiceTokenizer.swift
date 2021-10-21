//
//  SKCloudServiceTokenizer.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.10.2021.
//

import Foundation
import StoreKit

class SKCloudServiceTokenizer {
    
    func generateAuth(developerToken: String, appContainer: ApplicationContainer) {
        SKCloudServiceController.requestAuthorization { status in
            print("Authentication requested")
            if status == .authorized {
                UserToken(developerToken: developerToken).generateToken { result in
                    print("Authorized")
                    switch result {
                    case .success(let token):
                        let musicAPI = AppleMusicFeed(developerToken: developerToken, userToken: token)
                        musicAPI.fetch(request: APIRequest.getStoreFront(), model: Storefront.self) { result in
                            switch result {
                            case .success(let response):
                                guard let id = response.data?[0].id else { return }
                                DispatchQueue.main.async {
                                    let worker = LibraryWorker(musicAPI: musicAPI, storeFrontID: id)
                                    let libraryVC = LibraryViewController(musicAPI: musicAPI, storefrontID: id, worker: worker)
                                    appContainer.navController.setViewControllers([libraryVC], animated: true)
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } else {
                let alertVC = UIAlertController(title: "Apple Music Permission Required", message: nil, preferredStyle: .alert)
                appContainer.present(alertVC, animated: true)
            }
        }
    }
    
}
