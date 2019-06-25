//
//  Movie+CoreDataProperties.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 20/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var voteAverage: String?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var sorting: String?

}
