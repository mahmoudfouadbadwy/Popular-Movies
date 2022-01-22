//
//  Home.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit
import Combine
class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var collection: UICollectionView!
    
    //MARK: - Properties
    private var moviesViewModel: MoviesBusiness = MoviesViewModel()
    private var movies = [MoviesData.ViewModel]() {
        didSet {
            collection.reloadData()
        }
    }
    private var indicator: UIActivityIndicatorView!
    private var subscription = Set<AnyCancellable>()
    private var refreshControl: UIRefreshControl!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        moviesViewModel.getPopularMovies()
        bindMovies()
    }
    
    //MARK: - UI
    private func setupUI() {
        setupRefreshControl()
        setupIndicator()
        setupSortingButton()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.navigationItem.title = Strings.Title.popular
    }
    
    private func setupIndicator() {
        indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.center = view.center
        view.addSubview(indicator)
    }
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: Strings.Message.pull)
        refreshControl.tintColor = .white
        collection.addSubview(refreshControl)
    }
    
    private func setupSortingButton() {
        let sortingButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortingMenu))
        self.tabBarController?.navigationItem.rightBarButtonItem = sortingButton
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
            self?.tabBarController?.navigationItem.title = Strings.Title.topRated
        }
        menu.addAction(highestButton)
        
        let popularButton = UIAlertAction(title: popTitle, style: .default) {[weak self] _ in
            self?.moviesViewModel.isPopularMovies = true
            self?.moviesViewModel.getPopularMovies()
            self?.tabBarController?.navigationItem.title = Strings.Title.popular
        }
        menu.addAction(popularButton)
        
        let cancelButton = UIAlertAction(title: Strings.Title.cancel, style: .cancel) { _ in
            menu.dismiss(animated: true, completion: nil)
        }
        menu.addAction(cancelButton)
        self.present(menu, animated: true)
    }
    
    //MARK: - UILogic
    private func bindMovies() {
        indicator.startAnimating()
        moviesViewModel
            .movies
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.movies = movies
            }
            .store(in: &subscription)
    }
    
    //MARK: - Routing
    private func routeToMovieDetails(with movie: MoviesData.ViewModel) {
        guard let details = self.getController(MovieDetailsController.self, fromBoard: "Main") else {
            return
        }
        details.movieID = movie.id
        self.navigate(to: details)
    }
}


extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.routeToMovieDetails(with: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let countOfMoviesInRow = 2
        let countOfMoviesPerPage = 20
        let movies =  self.movies
        
        if self.movies.count <= 60 {
            self.moviesViewModel.saveMovieInStorage(movie: self.movies[indexPath.row])
        }
        if indexPath.row == movies.count - countOfMoviesInRow {
            let pageNo = (movies.count / countOfMoviesPerPage) + 1
            moviesViewModel.getMoviesInNext(page: pageNo)
        }
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.Cell.movie, for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        let movie = movies[indexPath.row]
        cell.configCell(imagePath: movie.moviePoster)
        return cell
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
