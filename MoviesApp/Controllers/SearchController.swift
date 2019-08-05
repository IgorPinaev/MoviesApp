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
    
    private let disposeBag = DisposeBag()
    private var movies: [MovieStruct] = [] {
        didSet {
            searchCollection.reloadData()
        }
    }
    private var selectedMovie: MovieStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SearchController.longPressGestureRecognized(_:)))
        searchCollection.addGestureRecognizer(longPress)
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer.location(in: searchCollection)
        let indexPath = searchCollection.indexPathForItem(at: longPress)
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            if let index = indexPath?.row {
                share(movie: movies[index], completionHandler: nil)
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
extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieInCell = movies[indexPath.row]
        selectedMovie = movieInCell
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
}
extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        searchCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.initCell(name: movie.title, rating: movie.voteAverage, image: movie.posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeader", for: indexPath) as! SearchBarReusableView
            headerView.delegate = self
            return headerView
        }
        
        return UICollectionReusableView()
    }
}
extension SearchController: SearchBarReusableViewDelegate {
    func searchBarDidChange(query: String) {
        if query == "" {
            movies = []
            return
        }
        APIController.sharedInstance.loadData(type: ResponseMovie.self, path: .search, queryItems: [SortQuery.onlyKey.parameters[0], URLQueryItem(name: "language", value: Locale.current.languageCode), URLQueryItem(name: "query", value: query)])
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                self.movies = response.results
            }, onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: self.disposeBag)
    }
}
extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10 - 16) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
