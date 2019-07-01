//
//  FavouritesController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 13/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class FavouritesController: UIViewController {

    @IBOutlet private weak var favouritesCollection: UICollectionView!
    private var selectedMovie: MovieStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(FavouritesController.longPressGestureRecognized(_:)))
        favouritesCollection.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesCollection.reloadData()
    }

    
    private func share (index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let movie = favourites[index]
        
            alert.addAction(UIAlertAction(title: "Remove from favourites", style: .destructive, handler: { (action) in
                CoreDataManager.sharedInstance.managedObjectContext.delete(movie)
                CoreDataManager.sharedInstance.saveContext()
                self.favouritesCollection.reloadData()
            }))
        
        alert.addAction(UIAlertAction(title: "Detalize", style: .default, handler: { (action) in
            self.selectedMovie = movie.toStruct()
            self.performSegue(withIdentifier: "goToDetail", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension FavouritesController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieInCell = favourites[indexPath.row].toStruct()
        cell.initCell(name: movieInCell.title, image: movieInCell.posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieInCell = favourites[indexPath.row]
        selectedMovie = movieInCell.toStruct()
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer.location(in: favouritesCollection)
        let indexPath = favouritesCollection.indexPathForItem(at: longPress)
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

extension FavouritesController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width - 10) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
