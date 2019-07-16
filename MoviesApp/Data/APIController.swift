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
    
    static let sharedInstance = APIController()
    private var isLoading = false
    
    private let apiKey = "f4a4f31e66aac2fecccbb82d591aaa36"
    private let youtube = "https://www.youtube.com/watch?v="
    
    func loadData<T: Decodable>(type: T.Type, path: Path, queryItems: [URLQueryItem]?) -> Observable<T> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = path.fullPath
        components.queryItems = [URLQueryItem(name: "api_key", value: self.apiKey), URLQueryItem(name: "language", value: Locale.current.languageCode)]
        if let queryItems = queryItems {
            components.queryItems?.append(contentsOf: queryItems)
        }
        guard let url = components.url else {return Observable.error(APIControllerErrors.invalidURL)}
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.rx.data(request: urlRequest).flatMap({ (data) -> Observable<T> in
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
