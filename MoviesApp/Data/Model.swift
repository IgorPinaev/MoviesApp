//
//  Model.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 19/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    static let sharedInstance = Model()
    private var isLoading = false
    
    private let baseUrl: String = "https://api.themoviedb.org/3/discover/movie"
    private let trailersUrl = "https://api.themoviedb.org/3/movie/301528/videos"
    private let reviewsUrl = "https://api.themoviedb.org/3/movie/301528/reviews"
    
    private let apiKey = "f4a4f31e66aac2fecccbb82d591aaa36"
    private let youtube = "https://www.youtube.com/watch?v="
    
    func loadData(sortBy: String, page: Int, completionHandler: ((_ result: Response?, _ error: String?)-> Void)?) {
        guard !isLoading else {return}
        
        isLoading = true
        
        guard let url = URL(string: "\(baseUrl)\(sortBy)&language=\((Locale.current.languageCode ?? "en"))&page=\(page)" ) else {
            isLoading = false
            completionHandler?(nil, "Error")
            return
        }
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) {(data, responce, error) in
            guard let data = data else {
                if let error = error {
                    self.isLoading = false
                    completionHandler?(nil, error.localizedDescription)
                }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do{
                let array = try decoder.decode(Response.self, from: data)
                self.isLoading = false
                completionHandler?(array, nil)
            } catch {
                self.isLoading = false
                completionHandler?(nil, error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
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
    
    func getData<T: Decodable>(type: T.Type, queryItems: [URLQueryItem], completionHandler: ((_ result: T?, _ error: String?)-> Void)?) {
        guard !isLoading else {return}
        isLoading = true
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/discover/movie"
        components.queryItems = queryItems
        components.queryItems?.insert(URLQueryItem(name: "api_key", value: apiKey), at: 0)
        guard let url = components.url
            else {
            isLoading = false
            return
        }
        print(url)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, responce, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                self.isLoading = false
                return
            }
            
            let response = self.parseJson(data: data, type: type)
            completionHandler?(response, nil)
        }
        
        dataTask.resume()
    }
}
