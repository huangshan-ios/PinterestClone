//
//  CollectionsCoordinator.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation
import UIKit

class CollectionsCoordinator: Coordinator {
    
    override func start() {
        let collectionsViewController = CollectionsViewController.instantiateFromStoryboard()
        collectionsViewController.viewModel = CollectionsViewModel()
        collectionsViewController.coordinator = self
        collectionsViewController.environment = CollectionsService()
        navigationController.viewControllers = [collectionsViewController]
    }
    
}
