//
//  DetailsVM.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/19/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MoviewDetailsBusiness {
    var  movieDetails: BehaviorRelay<MovieDetailsData.ViewModel> {get}
    func getMovieDetails(movieId: Int)
    func checkIsFavorite(movieId: Int)-> Bool
    func unFavorite()
    func makeFavorite()
}

protocol MovieReviewsBusiness {
    var movieReviews: BehaviorRelay<[Review.ViewModel]> {get set}
    func getReviews(by movieId: Int)
}

protocol MoviewTrailersBusiness {
    var movieTrailers: BehaviorRelay<[Trailer.viewModel]> {get set}
    func getTrailers(by movieId: Int)
}

class MovieDetailsViewModel: MoviewDetailsBusiness, MovieReviewsBusiness, MoviewTrailersBusiness {
    
    // MARK:- Properties
    private let bag = DisposeBag()
    var movieDetails: BehaviorRelay<MovieDetailsData.ViewModel> = BehaviorRelay(value: MovieDetailsData.fakeMovie)
    var movieTrailers: BehaviorRelay<[Trailer.viewModel]> =  BehaviorRelay(value: [])
    var movieReviews: BehaviorRelay<[Review.ViewModel]> = BehaviorRelay(value: [])
    
    //MARK:- Intents
    func getMovieDetails(movieId: Int) {
        if Networking.isNetworkEnabled {
            getOnlineDetails(movieId)
        } else {
           getOfflineDetails(movieId)
        }
    }
    
    func checkIsFavorite(movieId: Int)-> Bool {
        LocalStorage.shared.checkIsFavourite(id: movieId)
    }
    func unFavorite() {
        LocalStorage.shared.deleteFromFavourite(id: movieDetails.value.id)
    }
    func makeFavorite() {
        LocalStorage.shared.addToFavourite(movie: movieDetails.value)
    }
    func getReviews(by movieId: Int) {
        MovieDetailsWorker
            .getReviews(by: movieId)
            .subscribe(onNext: { [weak self] data in
                let viewModelArr = data.results.map { movie in
                    Review.ViewModel(author: movie.author, review: movie.content)
                }
                self?.movieReviews.accept(viewModelArr)
            })
            .disposed(by: bag)
    }
    func getTrailers(by movieId: Int) {
        MovieDetailsWorker
            .getTrailers(by: movieId)
            .subscribe(onNext: { [weak self] data in
                let viewModelArr = data.results.map { movie  in
                    Trailer.viewModel(key: movie.key, name: movie.name)
                }
                self?.movieTrailers.accept(viewModelArr)
            })
            .disposed(by: bag)
    }
    
    private func getOnlineDetails(_ movieID: Int) {
        MovieDetailsWorker
            .getMovieDetails(by: movieID)
            .subscribe(onNext: { [weak self] movie in
               let vmMovie = MovieDetailsData.ViewModel(moviePoster: movie.posterPath, id: movie.id, originalTitle: movie.originalTitle, overview: movie.overview, voteAverage: movie.voteAverage, releaseDate: movie.releaseDate)
                self?.movieDetails.accept(vmMovie)
            })
            .disposed(by: bag)
    }
    
    private func getOfflineDetails(_ movieID: Int) {
        guard let movie = LocalStorage.shared.getMovieBy(id: movieID) else { return }
        let vmMovie = MovieDetailsData.ViewModel(moviePoster: movie.poster ?? "", id: Int(movie.id), originalTitle: movie.name ?? "", overview: movie.overview ?? "", voteAverage: movie.rate , releaseDate: movie.mRelease ?? "")
        self.movieDetails.accept(vmMovie)
    }
}
