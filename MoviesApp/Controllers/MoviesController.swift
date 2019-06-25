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
    
    private let baseUrl: String = "https://api.themoviedb.org/3/discover/movie?api_key=f4a4f31e66aac2fecccbb82d591aaa36&language=en-US&include_adult=false&include_video=false&sort_by="
    
    private var sortBy = ""
    
    var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sortControl.selectedSegmentIndex = 0
        changeSortingAction(sortControl)
        //&page=1

    }
    
    @IBAction func changeSortingAction(_ sender: UISegmentedControl) {
        switch sortControl.selectedSegmentIndex {
        case 0:
            sortBy = "popularity.desc"
            
        case 1:
            sortBy = "vote_average.desc"
            
        case 2:
            sortBy = "release_date.asc"
            
        default:
            break
        }
        Model.sharedInstance.loadData(stringURL: baseUrl + sortBy, sortBy: sortBy ) {
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
            }
        }
    }
    
   
    

}
extension MoviesController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return movies.count
        return CoreDataManager.sharedInstance.moviesSorted(sorting: sortBy).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieInCell = CoreDataManager.sharedInstance.moviesSorted(sorting: sortBy)[indexPath.row]
        cell.initCell(name: movieInCell.title!, image: movieInCell.posterPath!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movieInCell = CoreDataManager.sharedInstance.moviesSorted(sorting: sortBy)[indexPath.row]
        selectedMovie = movieInCell
        performSegue(withIdentifier: "goToDetail", sender: self)
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
