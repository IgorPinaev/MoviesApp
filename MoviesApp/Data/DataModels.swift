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

struct ResponseTrailer: Codable {
    let id: Int
    let results: [TrailerStruct]
}

struct TrailerStruct: Codable {
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
