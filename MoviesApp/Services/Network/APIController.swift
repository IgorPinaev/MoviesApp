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

protocol APIControllerProtocol {
    func loadData<T: Decodable>(with type: T.Type, request: RequestData) -> Observable<T>
}

class APIController: APIControllerProtocol {
    static let shared = APIController()
    
    func loadData<T: Decodable>(with type: T.Type, request: RequestData) -> Observable<T> {
        return perform(request)
            .flatMap { [weak self] (request) -> Observable<Data> in
                guard let self = self else { return Observable.error(APIControllerErrors.unknownError)}
                return self.getData(with: request)
        }
            .flatMap { [weak self] (data) -> Observable<T> in
                guard let self = self else { return Observable.error(APIControllerErrors.unknownError)}
                return self.parse(from: data, with: T.self)
        }
    }
    
    private func perform(_ request: RequestData) -> Observable<URLRequest> {
        guard var urlComponents = URLComponents(string: request.absoluteUrl) else { return Observable.error(APIControllerErrors.invalidURL) }
        urlComponents.queryItems = request.params.compactMap({ (param) -> URLQueryItem in
            return URLQueryItem(name: param.key, value: param.value)
        })
        guard let url = urlComponents.url else { return Observable.error(APIControllerErrors.invalidURL)}
        return Observable.just(URLRequest(url: url))
    }
    
    private func getData(with request: URLRequest) -> Observable<Data> {
        return URLSession.shared.rx.data(request: request)
    }
    
    private func parse<T:Decodable>(from data: Data, with type: T.Type) -> Observable<T>{
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(T.self, from: data)
            return Observable.just(response)
        } catch {
            return Observable.error(APIControllerErrors.decodingError)
        }
    }
    
}
