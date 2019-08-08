//
//  Model.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 19/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class APIController {
    static let shared = APIController()
    
    func loadData<T: Decodable>(type: T.Type, path: Path, queryItems: [URLQueryItem]?) -> Observable<T> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = path.fullPath
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        guard let url = components.url else {return Observable.error(APIControllerErrors.invalidURL)}
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.rx.data(request: urlRequest)
            .flatMap({ (data) -> Observable<T> in
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(T.self, from: data)
                    return Observable.just(response)
                } catch {
                    return Observable.error(APIControllerErrors.decodingError)
                }
            })
    }
}
