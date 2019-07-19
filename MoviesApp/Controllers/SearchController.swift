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
    private var selectedMovie: MovieStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollection.rx.setDelegate(self).disposed(by: disposeBag)
        
        movies.bind(to: searchCollection.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { (indexPath, movie, cell) in
            cell.initCell(name: movie.title, image: movie.posterPath)
            }.disposed(by: disposeBag)
        
        
        searchBar.rx.text
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (query) in
                if query != "" {
                    APIController.sharedInstance.loadData(type: ResponseMovie.self, path: .search, queryItems: [SortQuery.onlyKey.parameters[0], URLQueryItem(name: "query", value: query)])
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { (response) in
                            self.movies.accept(response.results)
                        }, onError: { (error) in
                            print(error.localizedDescription)
                        })
                        .disposed(by: self.disposeBag)
                } else {
                    self.movies.accept([])
                }
            })
            .disposed(by: disposeBag)
        
        searchCollection.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                let movieInCell = self?.movies.value[indexPath.row]
                self?.selectedMovie = movieInCell
                self?.performSegue(withIdentifier: "goToDetail", sender: self)
            })
            .disposed(by: disposeBag)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SearchController.longPressGestureRecognized(_:)))
        searchCollection.addGestureRecognizer(longPress)
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer.location(in: searchCollection)
        let indexPath = searchCollection.indexPathForItem(at: longPress)
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            if let index = indexPath?.row {
                share(movie: movies.value[index])
            }
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            guard let destination = segue.destination as? DetailController else {return}
            destination.movie = selectedMovie
        }
    }
}
extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
