//
//  DetailController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 26/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var originalTitleLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    var movie: MovieStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        releaseLabel.text = movie.releaseDate
        voteLabel.text = movie.voteAverage?.description
        overviewLabel.text = movie.overview
        
        guard let image = self.movie?.posterPath,
            let url = URL(string: "https://image.tmdb.org/t/p/original" + image) else {
                self.posterImage.image = UIImage(named: "movie")
                return
        }
        posterImage.kf.setImage(with: url)
        
        
        //        APIController.sharedInstance.getData(type: ResponseVideo.self, path: .videos(id: movie.id!), queryItems: nil) { (response, error) in
        //            print(response)
        //        }
        //
        //        APIController.sharedInstance.getData(type: ResponseReview.self, path: .reviews(id: movie.id!), queryItems: nil) { (response, error) in
        //            print(response)
        //        }
    }
}
