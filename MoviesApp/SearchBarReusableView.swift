//
//  SearchBarReusableView.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 02/08/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol SearchBarReusableViewDelegate: class {
    func searchBarDidChange(query: String)
}

class SearchBarReusableView: UICollectionReusableView {
    @IBOutlet var searchBar: UISearchBar!
    weak var delegate: SearchBarReusableViewDelegate!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.rx.text
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (query) in
                self.delegate.searchBarDidChange(query: query ?? "")
            })
            .disposed(by: disposeBag)
    }
}
extension SearchBarReusableView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}
