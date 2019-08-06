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
    func share(movie: MovieStruct, completionHandler: (()-> Void)?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let favouriteIndex = favourites.firstIndex(where: {$0.id == movie.id && $0.title == movie.title && $0.originalTitle == movie.originalTitle && $0.releaseDate == movie.releaseDate && $0.overview == movie.overview && $0.posterPath == movie.posterPath && $0.voteAverage == movie.voteAverage}) {
            alert.addAction(UIAlertAction(title: "Remove from favourites".localize(), style: .destructive, handler: { (action) in
                CoreDataManager.sharedInstance.managedObjectContext.delete(favourites[favouriteIndex])
                CoreDataManager.sharedInstance.saveContext()
                completionHandler?()
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Add to favourites".localize(), style: .default, handler: { (action) in
                _ = Movie.addMovie(result: movie)
                CoreDataManager.sharedInstance.saveContext()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


