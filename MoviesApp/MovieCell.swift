//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 20/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    func initCell(name: String?, image: String?) {
        labelName.text = name
        self.movieImage.image = UIImage(named: "movie")
        
        DispatchQueue.global().async {
            if let image = image {
                if let url = URL(string: "https://image.tmdb.org/t/p/w300" + image){
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.movieImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}
