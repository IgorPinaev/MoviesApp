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
}

enum Path {
    case movies
    case videos(id: String)
    case reviews(id: String)
    
    var fullPath: String {
        switch self {
        case .movies:
            return "/3/discover/movie"
        case let .videos(id):
            return "/3/movies/\(id)/videos"
        case let .reviews(id):
            return "/3/movie/\(id)/reviews"
        }
    }
}
