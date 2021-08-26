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
    let tabBarController = UITabBarController()

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
        
        let tabBarItems = [UITabBarItem(title: "Tournaments", image: UIImage(named: "tournament"), tag: 0),
                           UITabBarItem(title: "Following", image: UIImage(systemName: "person.3.fill"), tag: 1),
                           UITabBarItem(tabBarSystemItem: .search, tag: 2),
                           UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 3),
                           UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)]
        let tabBarVCs = [UINavigationController(rootViewController: MainVC(style: .grouped)),
                         UINavigationController(rootViewController: FollowingVC()),
                         UINavigationController(rootViewController: TournamentSearchVC()),
                         UINavigationController(rootViewController: ProfileVC()),
                         UINavigationController(rootViewController: SettingsVC(style: .insetGrouped))]
        
        tabBarController.viewControllers = tabBarVCs.enumerated().map({ (index, navController) -> UINavigationController in
            navController.navigationBar.prefersLargeTitles = true
            navController.tabBarItem = tabBarItems[index]
            return navController
        })
        tabBarController.selectedIndex = 0
        
        window?.rootViewController = tabBarController
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
            presentErrorAlert("Unable to load smash.gg deeplink")
            return
        }
        
        let slug = String(url.absoluteString[url.absoluteString.index(range.upperBound, offsetBy: 0)...])
        NetworkService.getTournamentBySlug(slug) { [weak self] tournament, error in
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
                self?.tabBarController.selectedViewController?.present(alert, animated: true)
                return
            }
            guard let tournament = tournament else {
                self?.presentErrorAlert("No tournament found with this slug: \(slug)")
                return
            }
            
            let navViewController = self?.tabBarController.selectedViewController as? UINavigationController
            navViewController?.pushViewController(TournamentVC(tournament, cacheForLogo: .viewAllTournaments), animated: true)
        }
    }
    
    private func presentErrorAlert(_ message: String) {
        let alert = UIAlertController(title: k.Error.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        tabBarController.selectedViewController?.present(alert, animated: true)
    }
}
