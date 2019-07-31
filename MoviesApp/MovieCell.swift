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
    @IBOutlet private var stackRating: RatingView!
    
    func initCell(name: String?, rating: Double?, image: String?) {
        contentView.layer.cornerRadius = 3.0
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = UIColor.white.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        labelName.text = name
        if rating != 0.0 {
            labelRating.text = rating?.description
        } else {
            labelRating.text = ""
        }
        stackRating.rating = rating
        let image = image ?? ""
        let url = URL(string: "https://image.tmdb.org/t/p/w300" + image)
        movieImage.kf.setImage(with: url, placeholder: UIImage(named: "moviePlaceholder"))
    }
}
