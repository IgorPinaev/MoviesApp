//
//  AlertShare.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 19/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func share(movie: MovieStruct) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let favouriteIndex = favourites.firstIndex(where: {$0.id == movie.id && $0.title == movie.title && $0.originalTitle == movie.originalTitle && $0.releaseDate == movie.releaseDate && $0.overview == movie.overview && $0.posterPath == movie.posterPath && $0.voteAverage == movie.voteAverage})
        
        if favouriteIndex == nil {
            alert.addAction(UIAlertAction(title: "Add to favourites", style: .default, handler: { (action) in
                _ = Movie.addMovie(result: movie)
                CoreDataManager.sharedInstance.saveContext()
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Remove from favourites", style: .destructive, handler: { (action) in
                CoreDataManager.sharedInstance.managedObjectContext.delete(favourites[favouriteIndex!])
                CoreDataManager.sharedInstance.saveContext()
            }))
        }
        
//        alert.addAction(UIAlertAction(title: "Detalize", style: .default, handler: { (action) in
//
//            self.selectedMovie = movie
//            self.performSegue(withIdentifier: "goToDetail", sender: self)
//        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


