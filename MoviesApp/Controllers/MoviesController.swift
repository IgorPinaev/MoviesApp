//
//  MoviesController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 20/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class MoviesController: UIViewController {
    
    @IBOutlet private weak var moviesCollection: UICollectionView!
    @IBOutlet private weak var sortControl: UISegmentedControl!
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let container: UIView = UIView()
    private let refreshControl = UIRefreshControl()
    
    private var sortBy = ""
    private var selectedMovie: MovieStruct?
    private var movies: [MovieStruct] = []
    private var page: Int = 1
    private var queryItems: [URLQueryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        moviesCollection.refreshControl = refreshControl
        
        sortControl.selectedSegmentIndex = 0
        changeSortingAction(sortControl)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MoviesController.longPressGestureRecognized(_:)))
        moviesCollection.addGestureRecognizer(longPress)
    }
    
    @objc func refreshControlAction(_ sender: Any) {
        Model.sharedInstance.getData(type: ResponseMovie.self, path: .movies, queryItems: queryItems) { (response, error) in
            if let error = error{
                print(error)
            }
            
            if let response = response{
                self.movies = response.results
                self.page = response.page
            }
            DispatchQueue.main.async {
                self.moviesCollection.refreshControl?.endRefreshing()
                self.moviesCollection.reloadData()
                self.moviesCollection.contentOffset = .zero
            }
        }
        
    }
    
    @IBAction func changeSortingAction(_ sender: UISegmentedControl) {
        queryItems = []
        switch sortControl.selectedSegmentIndex {
        case 0:
            queryItems.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
        case 1:
            queryItems.append(URLQueryItem(name: "sort_by", value: "vote_average.desc"))
            queryItems.append(URLQueryItem(name: "vote_count.gte", value: "5000"))
        case 2:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d"
            let date = dateFormatter.string(from:Date())
            queryItems.append(URLQueryItem(name: "sort_by", value: "primary_release_date.asc"))
            queryItems.append(URLQueryItem(name: "primary_release_date.gte", value: date))
            queryItems.append(URLQueryItem(name: "region", value: Locale.current.regionCode ?? "US"))
        default:
            break
        }
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
    
    private func share(index: Int){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let movie = movies[index]
        
        if favourites.firstIndex(where: {$0.id == movie.id && $0.title == movie.title && $0.originalTitle == movie.originalTitle && $0.releaseDate == movie.releaseDate && $0.overview == movie.overview && $0.posterPath == movie.posterPath && $0.voteAverage == movie.voteAverage}) == nil {
            alert.addAction(UIAlertAction(title: "Add to favourites", style: .default, handler: { (action) in
                _ = Movie.addMovie(result: movie)
                CoreDataManager.sharedInstance.saveContext()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Detalize", style: .default, handler: { (action) in
            self.selectedMovie = movie
            self.performSegue(withIdentifier: "goToDetail", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension MoviesController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieInCell = movies[indexPath.row]
        cell.initCell(name: movieInCell.title, image: movieInCell.posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movieInCell = movies[indexPath.row]
        selectedMovie = movieInCell
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 4 {
            showActivityIndicator()
            queryItems.append(URLQueryItem(name: "page", value: String(page + 1)))
            Model.sharedInstance.getData(type: ResponseMovie.self, path: .movies, queryItems: queryItems) { (response, error) in
                if let error = error {
                    print(error)
                }
                if let response = response{
                    self.movies.append(contentsOf: response.results)
                    self.page = response.page
                    self.queryItems.remove(at: self.queryItems.count - 1)
                }
                DispatchQueue.main.async {
                    self.activityIndicator.removeFromSuperview()
                    self.container.removeFromSuperview()
                    self.moviesCollection.reloadData()
                }
            }
        }
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer.location(in: moviesCollection)
        let indexPath = moviesCollection.indexPathForItem(at: longPress)
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            if let index = indexPath?.row {
                share(index: index)
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
extension MoviesController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width - 10) / 2 
        return CGSize(width: width, height: width * 1.5)
    }
}
