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
    
    private let baseUrl: String = "https://api.themoviedb.org/3/discover/movie?api_key=f4a4f31e66aac2fecccbb82d591aaa36&language=en-US&include_adult=false&include_video=false&sort_by="
    
    func loadData(sortBy: String, page: Int, completionHandler: ((_ result: Response?, _ error: String?)-> Void)?) {
        guard !isLoading else {return}
        isLoading = true
        
        guard let url = URL(string: "\(baseUrl)\(sortBy)&page=\(page)" ) else {
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
}
