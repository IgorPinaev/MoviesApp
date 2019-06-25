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

    class func addMovie(sorting: String, dictionary: Dictionary<String, Any>) -> Movie{
        let movie = Movie(context: CoreDataManager.sharedInstance.managedObjectContext)
        movie.id = dictionary["id"] as? String ?? ""
        movie.title = dictionary["title"] as? String ?? ""
        movie.originalTitle = dictionary["original_title"] as? String ?? ""
        movie.overview = dictionary["overview"] as? String ?? ""
        movie.releaseDate = dictionary["release_date"] as? NSDate ?? NSDate() ///////
        movie.voteAverage = dictionary["vote_average"] as? String ?? ""
        movie.posterPath = dictionary["poster_path"] as? String ?? ""
        movie.sorting = sorting
        
        return movie
    }
}
