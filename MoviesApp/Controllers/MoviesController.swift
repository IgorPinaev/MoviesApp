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
    
    private let apiController: APIController = APIController.shared
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    
    private var selectedMovie: MovieStruct?
    private var page: Int = 1
    private var sorting: Int = 1
    
    private let disposeBag = DisposeBag()
    private let movies = BehaviorRelay<[MovieStruct]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        moviesCollection.refreshControl = refreshControl
        setActivityIndicator()
    
        moviesCollection.rx.setDelegate(self).disposed(by: disposeBag)
        moviesCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        movies.bind(to: moviesCollection.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { (indexPath, movie, cell) in
            cell.initCell(name: movie.title, rating: movie.voteAverage, image: movie.posterPath)
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
                self?.refreshControl.endRefreshing()
                self?.moviesCollection.contentOffset = .zero
                self?.movies.accept(response.results)
                })
            }, onError: { (error) in
                print(error.localizedDescription)
        })
            .disposed(by: disposeBag)
    }
    
    @IBAction func changeSortingAction(_ sender: UISegmentedControl) {
        sorting = sortControl.selectedSegmentIndex
        page = 1
        movies.accept([])
        refreshControl.beginRefreshing()
        refreshControlAction(self)
    }
    
    func setActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer.location(in: moviesCollection)
        let indexPath = moviesCollection.indexPathForItem(at: longPress)
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            if let index = indexPath?.row {
                addFavourite(movie: movies.value[index], saveAction: nil, completionHandler: nil)
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
        return apiController.loadData(with: ResponseMovie.self, request: .movies(sort: MoviesSort(rawValue: sorting) ?? MoviesSort.popularity, page: String(page)))
        .observeOn(MainScheduler.instance)
    }
}
extension MoviesController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.value.count - 4 {
            activityIndicator.startAnimating()
            page += 1
            loadMovies().subscribe(onNext: { [weak self] (response) in
                var movies = self?.movies.value ?? []
                movies.append(contentsOf: response.results)
                self?.movies.accept(movies)
                self?.page = response.page
                self?.activityIndicator.stopAnimating()
                }, onError: { (error) in
                    print(error.localizedDescription)
            })
                .disposed(by: disposeBag)
        }
    }
}
extension MoviesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10 - 16) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
