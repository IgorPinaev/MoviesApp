//
//  Movies.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 25/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation

struct ResponseMovie: Codable {
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

struct ResponseVideo: Codable {
    let id: Int
    let results: [VideoStruct]
}

struct VideoStruct: Codable {
    let name: String?
    let key: String?
}

struct ResponseReview: Codable {
    let id: Int
    let results: [ReviewStruct]
}

struct ReviewStruct: Codable {
    let author: String?
    let content: String?
}

enum Path {
    case movies
    case videos(id: Int32)
    case reviews(id: Int32)
    case search
    
    var fullPath: String {
        switch self {
        case .movies:
            return "/3/discover/movie"
        case let .videos(id):
            return "/3/movie/\(id)/videos"
        case let .reviews(id):
            return "/3/movie/\(id)/reviews"
        case .search:
            return "/3/search/movie"
        }
    }
}
