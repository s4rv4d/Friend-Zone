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
}
