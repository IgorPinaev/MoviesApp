//
//  SearchController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 18/07/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchController: UIViewController {

    @IBOutlet private var searchCollection: UICollectionView!
    @IBOutlet private var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    private let movies = BehaviorRelay<[MovieStruct]>(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()

        movies.bind(to: searchCollection.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { (indexPath, movie, cell) in
            cell.initCell(name: movie.title, image: movie.posterPath)
            }.disposed(by: disposeBag)

        
        searchBar.rx.text.orEmpty
        .distinctUntilChanged()
            .subscribe(onNext: { (query) in
                APIController.sharedInstance.loadData(type: ResponseMovie.self, path: .search, queryItems: [URLQueryItem(name: "api_key", value: "f4a4f31e66aac2fecccbb82d591aaa36"),
                    URLQueryItem(name: "query", value: query)])
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (response) in
                        self.movies.accept(response.results)
                    }, onError: { (error) in
                        print(error.localizedDescription)
                    })
                    .disposed(by: self.disposeBag)
            })
        .disposed(by: disposeBag)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }


}
extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
