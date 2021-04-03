//
//  Fav.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/6/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FavoriteViewController: UIViewController {
    
    //MARK:- Properties
    private let viewModel: FavoriteBusiness = FavoriteViewModel()
    private let cellIdentifier = "favouriteCell"
    private let bag = DisposeBag()
    private var indicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    //MARK:- IBOutlets
    @IBOutlet weak private var favCollection: UICollectionView!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getFavoriteMovies()
        bindMovies()
        moviesAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMovies()
    }
    
    //MARK:- UI
    private func setupUI() {
        setupMoviesCollection()
        setupIndicator()
        self.navigationItem.title = "Favorite Movies"
    }
    private func setupIndicator() {
        indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .red
        indicator.center = view.center
        view.addSubview(indicator)
    }
    private func setupMoviesCollection() {
        favCollection
            .rx
            .setDelegate(self)
            .disposed(by: bag)
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.tintColor = .red
        favCollection.addSubview(refreshControl)
    }
    @objc private func refreshMovies() {
        viewModel.getFavoriteMovies()
    }
    
    //MARK:- UILogic
    private func bindMovies() {
        self.indicator.startAnimating()
        viewModel
            .movies
            .bind(to: favCollection.rx.items(cellIdentifier: cellIdentifier, cellType: FavouriteCell.self)) {  (row , item , cell) in
                cell.configer(poster: item.moviePoster)
        }
        .disposed(by: bag)
        
        viewModel
            .movies
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
            })
            .disposed(by: bag)
    }
    
    //MARK:- Intent
    private func moviesAction() {
        favCollection
            .rx
            .modelSelected(MoviesData.ViewModel.self)
            .subscribe(onNext: { [weak self] movie in
                self?.routeToMovieDetails(with: movie)
            })
            .disposed(by: bag)
    }
    
    //MARK:- Routing
    private func routeToMovieDetails(with movie: MoviesData.ViewModel) {
        guard let movieDetailsController = getController(MovieDetailsController.self, fromBoard: "Main") else { return }
        movieDetailsController.movieID = movie.id
        self.navigate(to: movieDetailsController)
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width:  collectionView.bounds.size.width/2,
               height: collectionView.bounds.size.height/2)
    }
}
