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
    
    func loadData(stringURL: String, sortBy: String, completionHandler: (()-> Void)?) {
        guard let url = URL(string: stringURL) else {return}
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) {(data, responce, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
//                    if let error = error as? URLError, error.code == .notConnectedToInternet
//                    {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endRefreshing"), object: self)
//                        return
//                    }
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "error"), object: self)
                }
                return
            }
            CoreDataManager.sharedInstance.clear(sotring: sortBy)
            self.parseJSON(data: data, sortBy: sortBy)
            completionHandler?()
        }
        dataTask.resume()
        
    }
    
    func parseJSON(data: Data, sortBy: String) {
        let rootDictionaryAny = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let rootDictionary = rootDictionaryAny as? Dictionary<String, Any> else {return}
        
                if let array = rootDictionary["results"] as? [Dictionary<String, Any>] {
                    for dict in array {
                        _ = Movie.addMovie(sorting: sortBy, dictionary: dict)
                    }
                    CoreDataManager.sharedInstance.saveContext()
                }
    }
}
