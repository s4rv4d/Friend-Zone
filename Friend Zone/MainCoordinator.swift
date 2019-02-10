//
//  MainCoordinator.swift
//  test
//
//  Created by Sarvad shetty on 2/9/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
         let vc = ViewController.instantiate()
         vc.coordinator = self
         navigationController.pushViewController(vc, animated: false)
    }
    
    func configure(_ friend:Friend){
        let vc = FriendEditViewController.instantiate()
        vc.coordinator = self
        vc.friend = friend
        navigationController.pushViewController(vc, animated: true)
    }
    
    func updateData(_ friend:Friend){
        guard let vc = navigationController.viewControllers.first as? ViewController else{
            fatalError("couldnt init")
        }
        
        vc.update(fri: friend)
    }
}
