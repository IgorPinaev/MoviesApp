//
//  Movie+CoreDataClass.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 20/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    
    class func addMovie(result: MovieStruct) -> Movie {
        let movie = Movie(context: CoreDataManager.sharedInstance.managedObjectContext)
        movie.id = result.id ?? 0
        movie.title = result.title
        movie.originalTitle = result.originalTitle
        movie.overview = result.overview
        movie.posterPath = result.posterPath
        movie.releaseDate = result.releaseDate
        movie.voteAverage = result.voteAverage ?? 0.0
        return movie
    }
    
    func toStruct() -> MovieStruct {
        let movieStruct = MovieStruct(id: id, title: title, originalTitle: originalTitle, overview: overview, posterPath: posterPath, releaseDate: releaseDate, voteAverage: voteAverage)

        return movieStruct
    }
}
