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
    
    private let refreshControl = UIRefreshControl()
    private var sortBy = ""
    
    private var selectedMovie: MovieStruct?
    
    private var movies: [MovieStruct] = []
    private var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        moviesCollection.refreshControl = refreshControl
        
        sortControl.selectedSegmentIndex = 0
        changeSortingAction(sortControl)
        
    }
    
    @objc func refreshControlAction(_ sender: Any) {
        moviesCollection.refreshControl?.beginRefreshing()
        Model.sharedInstance.loadData(sortBy: sortBy, page: 1) { (response, error) in
            
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
        switch sortControl.selectedSegmentIndex {
        case 0:
            sortBy = "popularity.desc"
        case 1:
            sortBy = "vote_average.desc&vote_count.gte=5000"
        case 2:
            sortBy = "primary_release_date.asc&primary_release_date.gte=2019-06-27"
        default:
            break
        }
        refreshControlAction(self)
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
            Model.sharedInstance.loadData(sortBy: sortBy, page: page + 1) { (response, error) in
                if let error = error {
                    print(error)
                }
                if let response = response{
                    self.movies.append(contentsOf: response.results)
                    self.page = response.page
                }
                DispatchQueue.main.async {
                    self.moviesCollection.reloadData()
                }
            }
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
