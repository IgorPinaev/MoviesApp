//
//  OverviewCell.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 06/08/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class OverviewCell: UITableViewCell {

    @IBOutlet private var overviewLabel: UILabel!
    func initCell(overview: String?) {
        overviewLabel.text = overview
    }
}
