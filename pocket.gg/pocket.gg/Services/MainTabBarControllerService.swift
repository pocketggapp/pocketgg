//
//  MainTabBarControllerService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-08-26.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class MainTabBarControllerService {
    
    private static var tabBarController: UITabBarController?
    
    static func initTabBarController() -> UITabBarController? {
        if let tabBarController = tabBarController { return tabBarController }
        
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
        
        tabBarController = UITabBarController()
        tabBarController?.viewControllers = tabBarVCs.enumerated().map({ (index, navController) -> UINavigationController in
            navController.navigationBar.prefersLargeTitles = true
            navController.tabBarItem = tabBarItems[index]
            return navController
        })
        tabBarController?.selectedIndex = 0
        
        return tabBarController
    }
    
    static func deinitTabBarController() {
        tabBarController = nil
    }
    
    static func pushNewTournamentVC(_ tournament: Tournament) {
        let navViewController = tabBarController?.selectedViewController as? UINavigationController
        navViewController?.pushViewController(TournamentVC(tournament, cacheForLogo: .viewAllTournaments), animated: true)
    }
    
    static func presentErrorAlert(_ message: String) {
        let alert = UIAlertController(title: k.Error.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        tabBarController?.selectedViewController?.present(alert, animated: true)
    }
    
    static func presentAlertController(_ alert: UIAlertController) {
        tabBarController?.selectedViewController?.present(alert, animated: true)
    }
}
