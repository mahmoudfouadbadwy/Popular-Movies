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
    
    //MARK: - Properties
    private let viewModel: FavoriteBusiness = FavoriteViewModel()
    private let cellIdentifier = "favouriteCell"
    private let bag = DisposeBag()
    private var indicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    //MARK: - IBOutlets
    @IBOutlet weak private var favCollection: UICollectionView!
    
    //MARK: - Lifecycle
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
    
    //MARK: - UI
    private func setupUI() {
        setupMoviesCollection()
        setupIndicator()
        title = Strings.Title.favorite
    }
    private func setupIndicator() {
        indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.center = view.center
        view.addSubview(indicator)
    }
    private func setupMoviesCollection() {
        favCollection
            .rx
            .setDelegate(self)
            .disposed(by: bag)
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: Strings.Message.pull)
        refreshControl.tintColor = .white
        favCollection.addSubview(refreshControl)
    }
    @objc private func refreshMovies() {
        viewModel.getFavoriteMovies()
    }
    
    //MARK: - UILogic
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
    
    //MARK: - Intent
    private func moviesAction() {
        favCollection
            .rx
            .modelSelected(MoviesData.ViewModel.self)
            .subscribe(onNext: { [weak self] movie in
                self?.routeToMovieDetails(with: movie.id)
            })
            .disposed(by: bag)
    }
    
    //MARK: - Routing
    private func routeToMovieDetails(with movieID: Int) {
        guard let movieDetailsController = getController(MovieDetailsController.self, fromBoard: "Main") else { return }
        movieDetailsController.viewModel = MovieDetailsViewModel(movieID: movieID)   
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
