//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 20/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    @IBOutlet private var movieImage: UIImageView!
    @IBOutlet private var labelName: UILabel!
    @IBOutlet private var labelRating: UILabel!
    @IBOutlet var stackRating: RatingView!
    
    func initCell(name: String?, rating: Double?, image: String?) {
        labelName.text = name
        labelRating.text = rating?.description
        stackRating.rating = rating
        let image = image ?? ""
        let url = URL(string: "https://image.tmdb.org/t/p/w300" + image)
        movieImage.kf.setImage(with: url, placeholder: UIImage(named: "movie"))
    }
}
