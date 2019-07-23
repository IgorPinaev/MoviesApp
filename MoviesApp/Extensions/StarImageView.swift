//
//  StarImageView.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 23/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class StarImageView: UIImageView {
    
    enum State: String {
        case full
        case half
        case empty
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
