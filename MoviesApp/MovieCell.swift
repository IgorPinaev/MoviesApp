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
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    func initCell(name: String?, image: String?) {
        labelName.text = name

        guard let image = image else {return}
        let url = URL(string: "https://image.tmdb.org/t/p/w300" + image)
        movieImage.kf.setImage(with: url, placeholder: UIImage(named: "movie"))
    }
}
