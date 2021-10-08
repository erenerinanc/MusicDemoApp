//
//  AppDelegate.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 21.09.2021.
//

import UIKit
import CoreData
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        let loadingViewController = UIViewController()
        let indicator = UIActivityIndicatorView()
        loadingViewController.view.addSubview(indicator)
        indicator.snp.makeConstraints { $0.center.equalToSuperview() }
        
        let navController = UINavigationController(rootViewController: loadingViewController)
        navController.navigationBar.tintColor = .white

        navController.navigationBar.barTintColor = Colors.background
        navController.navigationBar.barStyle = .blackTranslucent
        navController.navigationBar.prefersLargeTitles = true

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        print("Application started")
        let developerToken = JWT.shared.generateToken()
        SKCloudServiceController.requestAuthorization { status in
            print("Authentication requested")
            if status == .authorized {
                UserToken(developerToken: developerToken).generateToken { result in
                    print("Authorized")
                    switch result {
                    case .success(let token):
                        let musicAPI = AppleMusicAPI(developerToken: developerToken, userToken: token)
                        musicAPI.fetch(request: APIRequest.getStoreFront(), model: Storefront.self) { result in
                            switch result {
                            case .success(let response):
                                guard let id = response.data?[0].id else { return }
                                DispatchQueue.main.async {
                                    let libraryVC = LibraryViewController(musicAPI: musicAPI, storefrontID: id)
                                    navController.setViewControllers([libraryVC], animated: true)
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
                loadingViewController.present(alertVC, animated: true)
            }
        }
          
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MusicDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

