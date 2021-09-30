//
//  AppCoordinator.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let collectionsCoordinator = CollectionsCoordinator()
        collectionsCoordinator.navigationController = navigationController
        start(collectionsCoordinator)

    }

}
