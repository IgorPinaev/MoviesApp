//
//  FavouritesController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 13/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavouritesController: UIViewController {
    @IBOutlet private var favouritesCollection: UICollectionView!
    private var selectedMovie: MovieStruct?
    private let disposeBag = DisposeBag()
    private let movies = BehaviorRelay<[Movie]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouritesCollection.rx.setDelegate(self).disposed(by: disposeBag)
        favouritesCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        movies.bind(to: favouritesCollection.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { (indexPath, movie, cell) in
            cell.initCell(name: movie.title, rating: movie.voteAverage, image: movie.posterPath)
            }.disposed(by: disposeBag)
        
        favouritesCollection.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                let movieInCell = self?.movies.value[indexPath.row].toStruct()
                self?.selectedMovie = movieInCell
                self?.performSegue(withIdentifier: "goToDetail", sender: self)
            })
            .disposed(by: disposeBag)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(FavouritesController.longPressGestureRecognized(_:)))
        favouritesCollection.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movies.accept(favourites)
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer.location(in: favouritesCollection)
        let indexPath = favouritesCollection.indexPathForItem(at: longPress)
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            if let index = indexPath?.row {
                addFavourite(movie: favourites[index].toStruct(), saveAction: nil) {
                    self.movies.accept(favourites)
                }
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
        let width = (UIScreen.main.bounds.width - 10 - 16) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
