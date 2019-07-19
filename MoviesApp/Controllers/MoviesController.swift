//
//  MoviesController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 20/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesController: UIViewController {
    @IBOutlet private var moviesCollection: UICollectionView!
    @IBOutlet private var sortControl: UISegmentedControl!
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let container: UIView = UIView()
    private let refreshControl = UIRefreshControl()
    
    private var selectedMovie: MovieStruct?
    private var page: Int = 1
    private var queryItems: [URLQueryItem] = []
    
    private let disposeBag = DisposeBag()
    private let movies = BehaviorRelay<[MovieStruct]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        moviesCollection.refreshControl = refreshControl
        
        moviesCollection.rx.setDelegate(self).disposed(by: disposeBag)
        movies.bind(to: moviesCollection.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { (indexPath, movie, cell) in
            cell.initCell(name: movie.title, image: movie.posterPath)
            }.disposed(by: disposeBag)
        
        sortControl.selectedSegmentIndex = 0
        changeSortingAction(sortControl)
        
        moviesCollection.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                let movieInCell = self?.movies.value[indexPath.row]
                self?.selectedMovie = movieInCell
                self?.performSegue(withIdentifier: "goToDetail", sender: self)
            })
            .disposed(by: disposeBag)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MoviesController.longPressGestureRecognized(_:)))
        moviesCollection.addGestureRecognizer(longPress)
    }
    
    @objc func refreshControlAction(_ sender: Any) {
        loadMovies().subscribe(onNext: { [weak self] (response) in
            self?.refreshControl.endRefreshing()
            self?.moviesCollection.contentOffset = .zero
            self?.movies.accept(response.results)
        }, onError: { (error) in
            print(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    @IBAction func changeSortingAction(_ sender: UISegmentedControl) {
        queryItems = SortQuery(rawValue: sortControl.selectedSegmentIndex)?.parameters ?? []
        page = 1
        refreshControlAction(self)
    }
    
    func showActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        
        container.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        container.center = view.center
        container.backgroundColor = UIColor(white: 0.6, alpha: 0.8)
        container.clipsToBounds = true
        container.layer.cornerRadius = 10
        
        view.addSubview(container)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer.location(in: moviesCollection)
        let indexPath = moviesCollection.indexPathForItem(at: longPress)
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
    
    private func loadMovies() -> Observable<ResponseMovie>{
        return APIController.sharedInstance.loadData(type: ResponseMovie.self, path: .movies, queryItems: queryItems)
            .observeOn(MainScheduler.instance)
    }
}
extension MoviesController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.value.count - 4 {
            showActivityIndicator()
            queryItems.append(URLQueryItem(name: "page", value: String(page + 1)))
            
            loadMovies().subscribe(onNext: { [weak self] (response) in
                var movies = self?.movies.value ?? []
                movies.append(contentsOf: response.results)
                self?.movies.accept(movies)
                self?.page = response.page
                self?.activityIndicator.removeFromSuperview()
                self?.container.removeFromSuperview()
                guard let count = self?.queryItems.count else {return}
                self?.queryItems.remove(at: count - 1)
                }, onError: { (error) in
                    print(error.localizedDescription)
            })
                .disposed(by: disposeBag)
        }
    }
}
extension MoviesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10) / 2 
        return CGSize(width: width, height: width * 1.5)
    }
}
