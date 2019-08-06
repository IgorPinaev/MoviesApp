//
//  DetailCell.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 06/08/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var originalTitleLabel: UILabel!
    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    
    func initCell(movie: MovieStruct?) {
        guard let movie = movie else {return}
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        releaseLabel.text = movie.releaseDate
        voteLabel.text = movie.voteAverage?.description
        
        posterImage.layer.cornerRadius = 3.0
        posterImage.layer.masksToBounds = true
        posterImage.layer.backgroundColor = UIColor.white.cgColor
        
        let image = movie.posterPath ?? ""
        let url = URL(string: "https://image.tmdb.org/t/p/original" + image)
        posterImage.kf.setImage(with: url, placeholder: UIImage(named: "moviePlaceholder"))
    }
}
