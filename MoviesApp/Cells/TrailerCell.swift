//
//  ReviewCell.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 16/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class TrailerCell: UITableViewCell {
    @IBOutlet private weak var labelTrailer: UILabel!
    
    func initCell(name: String?) {
        labelTrailer.text = name
    }
}
