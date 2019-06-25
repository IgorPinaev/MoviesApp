//
//  DetailController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 13/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelOriginalTitle: UILabel!
    @IBOutlet private weak var labelVote: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var labelOverview: UILabel!
    
    @IBOutlet private weak var imagePoster: UIImageView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if movie != nil {
            labelTitle.text = movie?.title
            labelOriginalTitle.text = movie?.originalTitle
//            labelDate.text = movie?.releaseDate
            labelVote.text = movie?.voteAverage
            labelOverview.text = movie?.overview
            
            let imagePath = "https://image.tmdb.org/t/p/w300" + movie!.posterPath!
                    if let url = URL(string: imagePath){
                        if let data = try? Data(contentsOf: url) {
                            imagePoster.image = UIImage(data: data)
                        }
                        else {
                            imagePoster.image = UIImage(named: "movie")
                        }
                    }
            
        }
    }
}
