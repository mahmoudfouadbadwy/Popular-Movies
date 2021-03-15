//
//  HomeVM.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/11/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


protocol MoviesBusiness {
    var movies: BehaviorRelay<[MovieViewModel]> {get}
    var isPopularMovies: Bool {get set}
    func getPopularMovies()
    func getTopRatedMovies()
    func getMoviesInNext(page: Int)
    func saveMovieInStorage(movie: MovieViewModel)
}

class MoviesViewModel: MoviesBusiness {
    
    var isPopularMovies = true
    var movies: BehaviorRelay<[MovieViewModel]> = BehaviorRelay(value: [])
    private let bag = DisposeBag()
    private let storage = LocalStorage.shared
    
    private func getMoviesIn(page: Int) {
        MoviesWorker
            .getMovies(page: page)
            .subscribe(onNext: {[weak self] movies in
                let moviesViewModel = movies.map { movie in
                    MovieViewModel(moviePoster: movie.posterPath,
                                   id: movie.id, originalTitle: movie.originalTitle,
                                   overview: movie.overview, voteAverage: movie.voteAverage,
                                   releaseDate: movie.releaseDate)
                }
                if page == 1 {
                    self?.movies.accept(moviesViewModel)
                } else {
                    let result = (self?.movies.value ?? []) + moviesViewModel
                    self?.movies.accept(result)
                }
            })
            .disposed(by: bag)
    }
    
    func getPopularMovies() {
        if Networking.isNetworkEnabled {
            getMoviesIn(page: 1)
        } else {
            let offlineMovies = getOfflineMovies()
            movies.accept(offlineMovies)
        }
    }
    
    func getTopRatedMovies() {
        if Networking.isNetworkEnabled {
            getTopRatedMoviesIn(page: 1)
        } else {
            let offlineMovies = getOfflineMovies()
            let topMovies = offlineMovies.sorted { Double(truncating: $0.voteAverage as NSNumber) > Double(truncating: $1.voteAverage as NSNumber) }
            movies.accept(topMovies)
        }
    }
    
    private func getTopRatedMoviesIn(page: Int) {
        MoviesWorker
            .getTopMovies(page: page)
            .subscribe(onNext: {[weak self] movies in
                let moviesViewModel = movies.map { movie in
                    MovieViewModel(moviePoster: movie.posterPath,
                                   id: movie.id, originalTitle: movie.originalTitle,
                                   overview: movie.overview, voteAverage: movie.voteAverage,
                                   releaseDate: movie.releaseDate)
                }
                if page == 1 {
                    self?.movies.accept(moviesViewModel)
                } else {
                    let result = (self?.movies.value ?? []) + moviesViewModel
                    self?.movies.accept(result)
                }
            })
            .disposed(by: bag)
    }
    
    func getMoviesInNext(page: Int) {
        if Networking.isNetworkEnabled{
            isPopularMovies ? getMoviesIn(page: page) : getTopRatedMoviesIn(page: page)
        }
    }
    
    func saveMovieInStorage(movie: MovieViewModel) {
        if Networking.isNetworkEnabled && storage.moviesCount <= 60 {
            storage.add(movie: movie)
        }
    }
    
    private func getOfflineMovies() -> [MovieViewModel] {
        let offlineMovies = storage.getMovies()
            .map { (movie)  in
                MovieViewModel(moviePoster: movie.value(forKey: "poster") as! String,
                               id: movie.value(forKey: "id") as! Int,
                               originalTitle: movie.value(forKey: "name") as! String,
                               overview: movie.value(forKey: "overview") as! String,
                               voteAverage: movie.value(forKey: "rate") as! Double,
                               releaseDate: movie.value(forKey: "mRelease") as! String)
        }
        
        return offlineMovies
    }
}




