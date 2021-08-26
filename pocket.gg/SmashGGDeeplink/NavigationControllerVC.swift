//
//  NavigationControllerVC.swift
//  SmashGGDeeplink
//
//  Created by Gabriel Siu on 2021-08-25.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class NavigationControllerVC: UINavigationController {
    
    init() {
        super.init(rootViewController: SmashGGDeeplinkVC())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
