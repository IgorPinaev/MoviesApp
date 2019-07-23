//
//  StarImageView.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 23/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import Foundation

class StarImageView: UIImageView {
    
    enum State: String {
        case full = "full"
        case half = "half"
        case empty = "empty"
    }
    
    var state: State? {
        didSet {
            guard let state = self.state else {
                return
            }
            self.image = UIImage(named: state.rawValue)
        }
    }
}
