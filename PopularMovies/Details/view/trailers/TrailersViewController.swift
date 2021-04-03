//
//  TrailersViewController.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/27/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrailersViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak private var trailersCollection: UICollectionView!
    
    //MARK:- Properties
    var movieId: Int!
    private let viewModel: MoviewTrailersBusiness = MovieDetailsViewModel()
    private let trailerCellIdentifier = Strings.Cell.trailer
    private let bag = DisposeBag()
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTrailers()
        setupUI()
        viewModel.getTrailers(by: movieId)
        setupCollectionAction()
    }
    
    //MARK:- UI
    private func setupUI() {
        navigationItem.title = Strings.Title.trailer
        trailersCollection
            .rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    //MARK:- UI Logic
    private func bindTrailers() {
        viewModel
            .movieTrailers
            .bind(to: trailersCollection.rx.items(cellIdentifier: trailerCellIdentifier, cellType: TrailerCell.self)){ (row , item , cell) in
                cell.config(title: item.name)
        }
        .disposed(by: bag)
    }
    
    private func setupCollectionAction() {
        trailersCollection
            .rx
            .modelSelected(Trailer.viewModel.self)
            .subscribe(onNext: { [weak self] movie in
                self?.openTrailer(by: movie.key)
            })
            .disposed(by: bag)
    }
    
    private func openTrailer(by key: String) {
        guard  var url = URL(string :"youtube://\(key)") else { return }
        if  !UIApplication.shared.canOpenURL(url)
        {
            url = URL(string: "https://www.youtube.com/watch?v=\(key)")!  // youtube app on phone
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)  // youtube on browser
    }
}


extension TrailersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width:  collectionView.bounds.size.width ,
               height: collectionView.bounds.size.height/3)
    }
}
