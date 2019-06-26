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

        if movie != nil {
            titleLabel.text = movie?.title
            originalTitleLabel.text = movie?.originalTitle
            releaseLabel.text = movie?.releaseDate
            voteLabel.text = movie?.voteAverage?.description
            overviewLabel.text = movie?.overview

            DispatchQueue.main.async {
                if let image = self.movie?.posterPath {
                    if let url = URL(string: "https://image.tmdb.org/t/p/w300" + image){
                        if let data = try? Data(contentsOf: url) {
                            self.posterImage.image = UIImage(data: data)
                            return
                        }
                    }
                }
                self.posterImage.image = UIImage(named: "movie")
            }
        }
    }
}
