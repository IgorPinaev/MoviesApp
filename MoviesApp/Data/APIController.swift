//
//  Model.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 19/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation

class APIController {
    
    static let sharedInstance = APIController()
    private var isLoading = false

    private let apiKey = "f4a4f31e66aac2fecccbb82d591aaa36"
    private let youtube = "https://www.youtube.com/watch?v="
    
    private func parseJson<T: Decodable>(data: Data, type: T.Type) -> T? {
        var response: T?
        var errorLocal: String?
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            response = try decoder.decode(type, from: data)
        } catch {
            errorLocal = error.localizedDescription
        }
        isLoading = false
        return response
    }
    
    func getData<T: Decodable>(type: T.Type, path: Path, queryItems: [URLQueryItem]?, completionHandler: ((_ result: T?, _ error: String?)-> Void)?) {
        guard !isLoading else {return}
        isLoading = true
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = path.fullPath
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let queryItems = queryItems {
            components.queryItems?.append(contentsOf: queryItems)
        }
        guard let url = components.url
            else {
                completionHandler?(nil, "The request failed")
                isLoading = false
                return
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, responce, error) in
            guard let data = data else {
                if let error = error {
                    completionHandler?(nil, error.localizedDescription)
                }
                self.isLoading = false
                return
            }
            let response = self.parseJson(data: data, type: T.self)
            completionHandler?(response, nil)
        }
        dataTask.resume()
    }
}
