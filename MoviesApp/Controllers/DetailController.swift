//
//  DetailController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 26/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: MovieStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        releaseLabel.text = movie.releaseDate
        voteLabel.text = movie.voteAverage?.description
        overviewLabel.text = movie.overview
        self.posterImage.image = UIImage(named: "movie")
        
        DispatchQueue.global().async {
            guard let image = self.movie?.posterPath,
                let url = URL(string: "https://image.tmdb.org/t/p/original" + image),
                let data = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.posterImage.image = UIImage(data: data)
            }
        }
    }
}
