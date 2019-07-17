//
//  ReviewCell.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 16/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet private weak var labelAuthor: UILabel!
    @IBOutlet private weak var labelReview: UILabel!
    
    func initCell(author: String?, review: String?) {
        labelAuthor.text = author
        labelReview.text = review
    }
}
