//
//  DetailController.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 26/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailController: UITableViewController {
    
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var originalTitleLabel: UILabel!
    @IBOutlet private var releaseLabel: UILabel!
    @IBOutlet private var voteLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
    @IBOutlet private var contentTable: UITableView!
    
    var movie: MovieStruct?
    private let behavior = BehaviorRelay<[ReviewStruct]>(value: [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        releaseLabel.text = movie.releaseDate
        voteLabel.text = movie.voteAverage?.description
        overviewLabel.text = movie.overview
        
        guard let image = self.movie?.posterPath,
            let url = URL(string: "https://image.tmdb.org/t/p/original" + image) else {
                self.posterImage.image = UIImage(named: "movie")
                return
        }
        posterImage.kf.setImage(with: url)
        
        behavior.bind(to: contentTable.rx.items(cellIdentifier: "ReviewCell", cellType: ReviewCell.self)) { (indexPath, review, cell) in
            cell.initCell(author: review.author, review: review.content)
            }.disposed(by: disposeBag)
        
        guard let id = movie.id else {return}
        APIController.sharedInstance.loadData(type: ResponseReview.self, path: .reviews(id: id), queryItems: SortQuery.onlyKey.parameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                self.behavior.accept(response.results)
            }, onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
