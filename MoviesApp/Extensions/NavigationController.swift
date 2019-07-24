//
//  NavigationController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 24/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
