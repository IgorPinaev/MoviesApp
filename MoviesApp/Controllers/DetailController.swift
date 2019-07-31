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
import SafariServices

class DetailController: UITableViewController {
    
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var originalTitleLabel: UILabel!
    @IBOutlet private var releaseLabel: UILabel!
    @IBOutlet private var voteLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
    @IBOutlet private var contentTable: UITableView!
    
    var movie: MovieStruct?
    private let trailers = BehaviorRelay<[TrailerStruct]>(value: [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        title = movie.title
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        releaseLabel.text = movie.releaseDate
        voteLabel.text = movie.voteAverage?.description
        overviewLabel.text = movie.overview
        
        posterImage.layer.cornerRadius = 3.0
        posterImage.layer.masksToBounds = true
        posterImage.layer.backgroundColor = UIColor.white.cgColor
        
        let image = self.movie?.posterPath ?? ""
        let url = URL(string: "https://image.tmdb.org/t/p/original" + image)
        posterImage.kf.setImage(with: url, placeholder: UIImage(named: "moviePlaceholder"))
        
        trailers.bind(to: contentTable.rx.items(cellIdentifier: "TrailerCell", cellType: TrailerCell.self)) { (indexPath, trailer, cell) in
            cell.initCell(name: trailer.name)
            }.disposed(by: disposeBag)
        
        guard let id = movie.id else {return}
        APIController.sharedInstance.loadData(type: ResponseTrailer.self, path: .trailers(id: id), queryItems: SortQuery.popularity.parameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response) in
                self?.tableView.performBatchUpdates({
                    self?.trailers.accept(response.results)
                })
            }, onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        contentTable.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                self?.contentTable.deselectRow(at: indexPath, animated: true)
                if let url = URL(string:"https://www.youtube.com/watch?v=" + (self?.trailers.value[indexPath.row].key)!) {
                    let safariVC = SFSafariViewController(url: url)
                    self?.present(safariVC, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return CGFloat(44 * (trailers.value.count + 1))
        }
            return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
