//
//  Home.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var collection: UICollectionView!
    
    //MARK:- Properties
    private var moviesViewModel: MoviesBusiness = MoviesViewModel()
    private var indicator: UIActivityIndicatorView!
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        moviesViewModel.getPopularMovies()
        bindMovies()
        moviesAction()
    }
    
    //MARK:- UI
    private func setupUI() {
        setupMoviesCollection()
        setupIndicator()
        setupSortingButton()
        self.navigationItem.title = Strings.Title.popular
    }
    
    private func setupIndicator() {
        indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .red
        indicator.center = view.center
        view.addSubview(indicator)
    }
    private func setupMoviesCollection() {
        collection
            .rx
            .setDelegate(self)
            .disposed(by: bag)
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: Strings.Message.pull)
        refreshControl.tintColor = .red
        collection.addSubview(refreshControl)
    }
    
    private func setupSortingButton() {
        let sortingButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortingMenu))
        self.navigationItem.rightBarButtonItem = sortingButton
    }
    
    @objc private func refreshMovies() {
        moviesViewModel.isPopularMovies = true
        moviesViewModel.getPopularMovies()
        self.navigationItem.title = Strings.Title.popular
    }
    
    @objc private func showSortingMenu() {
        let menu = UIAlertController(title: Strings.Title.sorting, message: Strings.Message.sort, preferredStyle: .actionSheet)
        let popTitle = moviesViewModel.isPopularMovies ? Strings.Title.popularSelected : Strings.Title.popularNormal
        let topTitle = moviesViewModel.isPopularMovies ? Strings.Title.topNormal : Strings.Title.topSelected
        let highestButton = UIAlertAction(title: topTitle, style: .default) {[weak self] _ in
            self?.moviesViewModel.isPopularMovies = false
            self?.moviesViewModel.getTopRatedMovies()
            self?.navigationItem.title = Strings.Title.topRated
        }
        menu.addAction(highestButton)
        
        let popularButton = UIAlertAction(title: popTitle, style: .default) {[weak self] _ in
            self?.moviesViewModel.isPopularMovies = true
            self?.moviesViewModel.getPopularMovies()
            self?.navigationItem.title = Strings.Title.popular
        }
        menu.addAction(popularButton)
        
        let cancelButton = UIAlertAction(title: Strings.Title.cancel, style: .cancel) { _ in
            menu.dismiss(animated: true, completion: nil)
        }
        menu.addAction(cancelButton)
        self.present(menu, animated: true)
    }
    
    //MARK:- UILogic
    private func bindMovies() {
        indicator.startAnimating()
        moviesViewModel
            .movies
            .bind(to: collection.rx.items(cellIdentifier: Strings.Cell.movie, cellType: MovieCell.self)) { [weak self](row , item , cell) in
                guard let self = self else { return }
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
                cell.configCell(imagePath: item.moviePoster)
                if self.moviesViewModel.movies.value.count <= 60 {
                    self.moviesViewModel.saveMovieInStorage(movie: item)
                }
        }
        .disposed(by: bag)
    }
    
    private func moviesAction() {
        collection
            .rx
            .modelSelected(MoviesData.ViewModel.self)
            .subscribe(onNext: { [weak self] movie in
                self?.routeToMovieDetails(with: movie)
            })
            .disposed(by: bag)
    }
    
    //MARK:- Routing
    private func routeToMovieDetails(with movie: MoviesData.ViewModel) {
        guard let details = self.getController(MovieDetailsController.self, fromBoard: "Main") else {
            return
        }
        details.movieID = movie.id
        self.navigate(to: details)
    }
}


extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let countOfMoviesInRow = 2
        let countOfMoviesPerPage = 20
        let movies =  self.moviesViewModel.movies.value
        
        if indexPath.row == movies.count - countOfMoviesInRow
        {
            let pageNo = (movies.count / countOfMoviesPerPage) + 1
            moviesViewModel.getMoviesInNext(page: pageNo)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width:  collectionView.bounds.size.width/2,
               height: collectionView.bounds.size.height/2)
    }
}
