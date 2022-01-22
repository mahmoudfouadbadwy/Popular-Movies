//
//  HomeVM.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/11/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import Foundation
import Combine

protocol MoviesBusiness {
    var movies: AnyPublisher<[MoviesData.ViewModel], Never> {get}
    var isPopularMovies: Bool {get set}
    func getPopularMovies()
    func getTopRatedMovies()
    func getMoviesInNext(page: Int)
    func saveMovieInStorage(movie: MoviesData.ViewModel)
}

class MoviesViewModel: MoviesBusiness {
    var isPopularMovies = true
    var movies: AnyPublisher<[MoviesData.ViewModel], Never> {
        currentMovies.eraseToAnyPublisher()
    }

    private var subscribtion = Set<AnyCancellable>()
    private let currentMovies = CurrentValueSubject<[MoviesData.ViewModel], Never>([])
    private let storage = LocalStorage.shared
    private let worker: WorkerBusinessLogic = MoviesWorker()
    
    private func getMoviesIn(page: Int) {
        worker
            .getMovies(page: page)
            .sink {completion in
                print("view model \(completion)")
            } receiveValue: { [weak self ] response in
                let moviesViewModel = response.movies.map { movie in
                    MoviesData.ViewModel(moviePoster: movie.posterPath,
                                   id: movie.id, originalTitle: movie.originalTitle,
                                   overview: movie.overview, voteAverage: movie.voteAverage,
                                   releaseDate: movie.releaseDate)
                }
                if page == 1 {
                    self?.currentMovies.value = moviesViewModel
                } else {
                    let result = (self?.currentMovies.value ?? []) + moviesViewModel
                    self?.currentMovies.value = result
                }
            }
            .store(in: &subscribtion)
    }
    
    func getPopularMovies() {
        if Networking.isNetworkEnabled {
            getMoviesIn(page: 1)
        } else {
            let offlineMovies = getOfflineMovies()
            currentMovies.value = offlineMovies
        }
    }
    
    func getTopRatedMovies() {
        if Networking.isNetworkEnabled {
            getTopRatedMoviesIn(page: 1)
        } else {
            let offlineMovies = getOfflineMovies()
            let topMovies = offlineMovies.sorted { Double(truncating: $0.voteAverage as NSNumber) > Double(truncating: $1.voteAverage as NSNumber) }
            currentMovies.value = topMovies
        }
    }
    
    private func getTopRatedMoviesIn(page: Int) {
        worker
            .getTopMovies(page: page)
            .sink { completed in
                print("view model \(completed)")
            } receiveValue: { [weak self ] response in
                let moviesViewModel = response.movies.map { movie in
                    MoviesData.ViewModel(moviePoster: movie.posterPath,
                                   id: movie.id, originalTitle: movie.originalTitle,
                                   overview: movie.overview, voteAverage: movie.voteAverage,
                                   releaseDate: movie.releaseDate)
                }
                if page == 1 {
                    self?.currentMovies.value = moviesViewModel
                } else {
                    let result = (self?.currentMovies.value ?? []) + moviesViewModel
                    self?.currentMovies.value = result
                }
            }
            .store(in: &subscribtion)
    }
    
    func getMoviesInNext(page: Int) {
        if Networking.isNetworkEnabled {
            isPopularMovies ? getMoviesIn(page: page) : getTopRatedMoviesIn(page: page)
        }
    }
    
    func saveMovieInStorage(movie: MoviesData.ViewModel) {
        if Networking.isNetworkEnabled && storage.moviesCount <= 60 {
            storage.add(movie: movie)
        }
    }
    
    private func getOfflineMovies() -> [MoviesData.ViewModel] {
        let offlineMovies = storage.getMovies()
            .map { (movie)  in
                MoviesData.ViewModel(moviePoster: movie.image ,
                               id: movie.identifier ,
                               originalTitle: movie.title,
                               overview: movie.notes,
                               voteAverage: movie.rate ,
                               releaseDate: movie.relase )
        }
        
        return offlineMovies
    }
}




