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
    var movieDetails: BehaviorRelay<MovieDetailsData.Response> {get}
    func getMovieDetails(MovieId: Int)
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
    var movieDetails: BehaviorRelay<MovieDetailsData.Response> = BehaviorRelay(value: MovieDetailsData.fakeMovie)
    
    //MARK:- Intents
    func getMovieDetails(MovieId: Int) {
        MovieDetailsWorker
            .getMovieDetails(by: MovieId)
            .subscribe(onNext: { [weak self] movie in
                self?.movieDetails.accept(movie)
            })
            .disposed(by: bag)
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
//}

//extension MovieDetailsViewModel: MovieReviewsBusiness {
    
    var movieReviews: BehaviorRelay<[Review.ViewModel]> = BehaviorRelay(value: [])
    //{ BehaviorRelay(value: []) }
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
//}

//extension MovieDetailsViewModel: MoviewTrailersBusiness {
    
    var movieTrailers: BehaviorRelay<[Trailer.viewModel]> =  BehaviorRelay(value: [])
    //{ BehaviorRelay(value: []) }
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
}
