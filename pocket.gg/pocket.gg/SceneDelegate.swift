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
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = tabBarVCs.enumerated().map({ (index, navController) -> UINavigationController in
            navController.navigationBar.prefersLargeTitles = true
            navController.tabBarItem = tabBarItems[index]
            return navController
        })
        tabBarController.selectedIndex = 0
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
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
}
