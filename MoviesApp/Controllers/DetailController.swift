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

class DetailController: UIViewController {
    
    @IBOutlet private var detailTable: UITableView!
    private let apiController: APIController = APIController.shared
    var movie: MovieStruct?
    private var trailers: [TrailerStruct] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        title = movie.title
        
        guard let id = movie.id else {return}
        apiController.loadData(type: ResponseTrailer.self, path: .trailers(id: id), queryItems: SortQuery.popularity.parameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response) in
                if response.results.count == 0 {return}
                for i in 0...response.results.count - 1 {
                    self?.trailers.append(response.results[i])
                    self?.detailTable.insertRows(at: [IndexPath(row: i + 2, section: 0)], with: .automatic)
                }
                }, onError: { (error) in
                    print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        var saveAction: UIAlertAction? = nil
        let cell = self.detailTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailCell
        guard let movie = movie, let image = cell?.posterImage.image else {return}
        if image != UIImage(named: "moviePlaceholder") {
            saveAction = UIAlertAction(title: "Save poster".localize(), style: .default, handler: {[weak self] (action) in
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
            })
        }

        addFavourite(movie: movie, saveAction: saveAction, completionHandler: nil)
    }
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        var alert: UIAlertController
        if let error = error {
            alert = UIAlertController(title: "Save error".localize(), message: error.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Saved".localize(), message: "Image has been saved to your photos".localize(), preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
extension DetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row > 1 {
            let key = trailers[indexPath.row - 2].key ?? "dQw4w9WgXcQ"
            if let url = URL(string:"https://www.youtube.com/watch?v=" + key) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
}
extension DetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailers.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
            cell.initCell(movie: movie)
            return cell
        } else
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell
                cell.initCell(overview: movie?.overview)
                return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath) as! TrailerCell
        cell.initCell(name: trailers[indexPath.row - 2].name)
        return cell
    }
}
