//
//  Home.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit
import RxSwift


class HomeViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var collection: UICollectionView!
    
    //MARK:- Properties
    private var moviesViewModel: MoviesBusiness = MoviesViewModel()
    private var indicator: UIActivityIndicatorView!
    private(set) var menuCellId = "cell"
    private let collectionCellId = "MovieCell"
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var movies: [MovieViewModel] = []{
        didSet {
            self.collection.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK:- Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        moviesViewModel.getPopularMovies()
        observeMovies()
        setupUI()
    }
    
    
    //MARK:- segue preparation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        guard let detail = segue.destination as? MovieDetailsController,
    //            let cell = sender as? UICollectionViewCell ,
    //            let indexPath = self.collection.indexPath(for: cell) else {
    //                return
    //        }
    //        detail.filmId = movies[indexPath.row].id
    //    }
    
    //MARK:- UI
    private func setupUI() {
        setupMoviesCollection()
        setupIndicator()
        setupSortingButton()
    }
    
    private func setupIndicator() {
        indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.center = view.center
        view.addSubview(indicator)
    }
    private func setupMoviesCollection() {
        collection.delegate = self
        collection.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.tintColor = .red
        collection.addSubview(refreshControl)
    }
    
    private func setupSortingButton() {
        let sortingButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortingMenu))
        self.navigationItem.rightBarButtonItem = sortingButton
    }
    
    //MARK:- UILogic
    private func observeMovies() {
        let movies = moviesViewModel.movies
        movies
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] data in
                self?.movies += data
                print("movies count  = \(self?.movies.count ?? 0)")
            })
            .disposed(by: bag)
    }
    
    @objc private func refreshMovies() {
        moviesViewModel.isPopularMovies = true
        movies = []
        moviesViewModel.getPopularMovies()
    }
    
    @objc private func showSortingMenu() {
        let menu = UIAlertController(title: "Please select sorting type", message: "Option to select", preferredStyle: .actionSheet)
        let popTitle = moviesViewModel.isPopularMovies ? "Popular  √" : "Popular"
        let topTitle = moviesViewModel.isPopularMovies ? "Highest rated" : "Highest rated  √"
        let highestButton = UIAlertAction(title: topTitle, style: .default) {[weak self] _ in
            self?.moviesViewModel.isPopularMovies = false
            self?.movies = []
            self?.moviesViewModel.getTopRatedMovies()
        }
        menu.addAction(highestButton)
        
        let popularButton = UIAlertAction(title: popTitle, style: .default) {[weak self] _ in
            self?.moviesViewModel.isPopularMovies = true
            self?.movies = []
            self?.moviesViewModel.getPopularMovies()
        }
        menu.addAction(popularButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            menu.dismiss(animated: true, completion: nil)
        }
        menu.addAction(cancelButton)
        self.present(menu, animated: true)
    }
}



extension HomeViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {  movies.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath) as? MovieCell  else {
            return UICollectionViewCell()
        }
        cell.configCell(imagePath: movies[indexPath.row].moviePoster)
        if movies.count <= 60 {
            moviesViewModel.saveMovieInStorage(movie: movies[indexPath.row])
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "detail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let countOfMoviesInRow = 2
        let countOfMoviesPerPage = 20
        
        if indexPath.row == movies.count - countOfMoviesInRow
        {
            let pageNo = (movies.count / countOfMoviesPerPage) + 1
            moviesViewModel.getMoviesInNext(page: pageNo)
        }
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width/2, height: CGFloat(collectionView.bounds.size.height/2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
