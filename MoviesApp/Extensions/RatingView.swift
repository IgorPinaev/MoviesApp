//
//  RatingView.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 23/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class RatingView: UIStackView {
    @IBOutlet private var firstImage: StarImageView!
    @IBOutlet private var secondImage: StarImageView!
    @IBOutlet private var thirdImage: StarImageView!
    @IBOutlet private var fourthImage: StarImageView!
    @IBOutlet private var fifthImage: StarImageView!
    
    private var images: [StarImageView] = []
    
    var rating: Double? {
        didSet {
            images = [firstImage, secondImage, thirdImage, fourthImage, fifthImage]
            setupRatingView()
        }
    }
    
    private func setupRatingView() {
        setNoneToAllStars()
        guard let rating = rating else {return}
        if rating == 0.0 {
            for image in images {
                image.image = nil
            }
            return
        }
        let fiveStarRating = rating / 2
        let ratingInt = Int(fiveStarRating)
        let half = fiveStarRating - Double(ratingInt)
        for index in 0..<ratingInt {
            images[index].state = .full
        }
        if half >= 0.5 && ratingInt < 5 {
            images[ratingInt].state = .half
        }
    }
    
    private func setNoneToAllStars() {
        for image in images {
            image.state = .empty
        }
    }
}
