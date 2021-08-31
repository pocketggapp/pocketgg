//
//  SceneDelegate.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-01-31.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.tintColor = .systemRed
        
        PinnedTournamentsService.initPinnedTournaments()
        TOFollowedService.initFollowedTOs()
        
        if !UserDefaults.standard.bool(forKey: k.UserDefaults.returningUser) {
            UserDefaults.standard.set(true, forKey: k.UserDefaults.showPinnedTournaments)
            UserDefaults.standard.set(true, forKey: k.UserDefaults.featuredTournaments)
            UserDefaults.standard.set(true, forKey: k.UserDefaults.upcomingTournaments)
            UserDefaults.standard.set(true, forKey: k.UserDefaults.firebaseEnabled)
        }
        
        guard let authToken = UserDefaults.standard.string(forKey: k.UserDefaults.authToken), !authToken.isEmpty else {
            window?.rootViewController = AuthTokenVC()
            window?.makeKeyAndVisible()
            return
        }
        
        window?.rootViewController = MainTabBarControllerService.initTabBarController()
        window?.makeKeyAndVisible()
        
        if let url = connectionOptions.urlContexts.first?.url {
            loadTournamentFromDeeplink(url: url, retryNum: 0)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        loadTournamentFromDeeplink(url: URLContexts.first?.url, retryNum: 0)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func loadTournamentFromDeeplink(url: URL?, retryNum: Int) {
        guard let url = url, let range = url.absoluteString.range(of: "pocketgg://") else {
            MainTabBarControllerService.presentErrorAlert("Unable to load smash.gg deeplink")
            return
        }
        
        let slug = String(url.absoluteString[url.absoluteString.index(range.upperBound, offsetBy: 0)...])
        TournamentInfoService.getTournamentBySlug(slug) { [weak self] tournament, error in
            if let error = error {
                // This network call has a tendency to fail sometimes; retry the network call up to a few times if this happens
                if retryNum < 3 {
                    self?.loadTournamentFromDeeplink(url: url, retryNum: retryNum + 1)
                    return
                }
                
                // TODO: Implement error handling for all network calls
                let alert = UIAlertController(title: k.Error.title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self?.loadTournamentFromDeeplink(url: url, retryNum: 3)
                }))
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                MainTabBarControllerService.presentAlertController(alert)
                return
            }
            guard let tournament = tournament else {
                MainTabBarControllerService.presentErrorAlert("No tournament found with this slug: \(slug)")
                return
            }
            
            MainTabBarControllerService.pushNewTournamentVC(tournament)
        }
    }
}
