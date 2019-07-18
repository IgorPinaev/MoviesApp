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

enum SortQuery: Int{
    case popularity
    case voteAverage
    case releaseDate
    case onlyKey
    
    var parameters: [URLQueryItem] {
        var queryItems = [URLQueryItem(name: "api_key", value: "f4a4f31e66aac2fecccbb82d591aaa36")]
        switch self {
        case .popularity:
            queryItems.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
        case .voteAverage:
            queryItems.append(contentsOf:[URLQueryItem(name: "sort_by", value: "vote_average.desc"),
                    URLQueryItem(name: "vote_count.gte", value: "5000")])
        case .releaseDate:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d"
            let date = dateFormatter.string(from:Date())
            queryItems.append(contentsOf: [URLQueryItem(name: "sort_by", value: "primary_release_date.asc"),
                    URLQueryItem(name: "primary_release_date.gte", value: date),
                    URLQueryItem(name: "region", value: Locale.current.regionCode ?? "US")])
        case .onlyKey:
            return queryItems
        }
        queryItems.append(URLQueryItem(name: "language", value: Locale.current.languageCode))
        return queryItems
    }
}

