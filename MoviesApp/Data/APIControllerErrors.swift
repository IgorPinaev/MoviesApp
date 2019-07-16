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
