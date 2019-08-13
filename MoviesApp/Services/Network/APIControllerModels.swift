//
//  APIControllerErrors.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 15/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation

enum APIControllerErrors: LocalizedError {
    case invalidURL
    case dataNil
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .dataNil:
            return "Empty data."
        case .decodingError:
            return "Data has invalid format."
        default:
            return "Something goes wrong."
        }
    }
}

enum RequestData {
    case movies(sort: MoviesSort, page: String)
    case trailers(id: Int32)
    case search(query: String)
    
    var urlString: String {
        return "https://api.themoviedb.org/3"
    }
    
    var absoluteUrl: String {
        switch self {
        case .movies:
            return urlString + "/discover/movie"
        case let .trailers(id):
            return urlString + "/movie/\(id)/videos"
        case .search:
            return urlString + "/search/movie"
        }
    }
    var params: [String: String] {
        var queryParams: [String: String] = ["api_key":"f4a4f31e66aac2fecccbb82d591aaa36", "language": Locale.current.languageCode ?? "en"]
        switch self {
        case let .movies(sort, page):
            queryParams.updateValue(page, forKey: "page")
            switch sort {
            case .popularity:
                queryParams.updateValue("popularity.desc", forKey: "sort_by")
                queryParams.updateValue("500", forKey: "vote_count.gte")
            case .voteAverage:
                queryParams.updateValue("vote_average.desc", forKey: "sort_by")
                queryParams.updateValue("5000", forKey: "vote_count.gte")
            case .releaseDate:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-d"
                let date = dateFormatter.string(from:Date())
                queryParams.updateValue("primary_release_date.asc", forKey: "sort_by")
                queryParams.updateValue(date, forKey: "primary_release_date.gte")
                queryParams.updateValue(Locale.current.regionCode ?? "US", forKey: "region")
            }
        case .trailers:
            return queryParams
        case let .search(query):
            queryParams.updateValue(query, forKey: "query")
        }
        return queryParams
    }
}

enum MoviesSort: Int {
    case popularity
    case voteAverage
    case releaseDate
}
