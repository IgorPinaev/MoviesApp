//
//  Movies.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 25/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation

struct Response: Codable {
    let page: Int
    let results: [MovieStruct]
}

struct MovieStruct: Codable {
    let id: Int32?
    let title: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case originalTitle = "original_title"
//        case overview
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case voteAverage = "vote_average"
//    }
}
