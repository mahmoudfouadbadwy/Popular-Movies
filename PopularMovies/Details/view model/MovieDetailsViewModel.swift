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
    var movieDetails: BehaviorRelay<MovieDetailsData.ViewModel> {get}
    func checkIsFavorite() -> Bool
    func unFavorite()
    func makeFavorite()
}

protocol MovieReviewsBusiness {
    var movieReviews: Driver<[Review.ViewModel]>! {get}
    func getReviews()
}

protocol MoviewTrailersBusiness {
    var movieTrailers: Driver<[Trailer.viewModel]>! {get}
    func getTrailers()
}

class MovieDetailsViewModel: MoviewDetailsBusiness {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var movieID: Int!
    var movieDetails: BehaviorRelay<MovieDetailsData.ViewModel> = BehaviorRelay(value: MovieDetailsData.fakeMovie)
    private var movieReviewsRelay: BehaviorRelay<[Review.ViewModel]> = BehaviorRelay(value: [])
    private var movieTrailersRelay: BehaviorRelay<[Trailer.viewModel]> =  BehaviorRelay(value: [])
    
    //MARK: - Init
    
    init(movieID: Int) {
        self.movieID = movieID
        getMovieDetails(movieId: movieID)
    }
    
    //MARK: - Behaviors
    func checkIsFavorite() -> Bool {
        LocalStorage.shared.checkIsFavourite(id: movieID)
    }
    func unFavorite() {
        LocalStorage.shared.deleteFromFavourite(id: movieDetails.value.id)
    }
    func makeFavorite() {
        LocalStorage.shared.addToFavourite(movie: movieDetails.value)
    }
    private func getMovieDetails(movieId: Int) {
        if Networking.isNetworkEnabled {
            getOnlineDetails(movieId)
        } else {
            getOfflineDetails(movieId)
        }
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


extension MovieDetailsViewModel: MovieReviewsBusiness {

    var movieReviews: Driver<[Review.ViewModel]>! {
        movieReviewsRelay.asDriver(onErrorJustReturn: [])
    }
    func getReviews() {
        MovieDetailsWorker
            .getReviews(by: movieID)
            .subscribe(onNext: { [weak self] data in
                let viewModelArr = data.results.map { movie in
                    Review.ViewModel(author: movie.author, review: movie.content)
                }
                self?.movieReviewsRelay.accept(viewModelArr)
            })
            .disposed(by: bag)
    }

}
extension MovieDetailsViewModel: MoviewTrailersBusiness {
    
    var movieTrailers: Driver<[Trailer.viewModel]>!{
        movieTrailersRelay.asDriver(onErrorJustReturn: [])
    }
    func getTrailers() {
        MovieDetailsWorker
            .getTrailers(by: movieID)
            .subscribe(onNext: { [weak self] data in
                let viewModelArr = data.results.map { movie  in
                    Trailer.viewModel(key: movie.key, name: movie.name)
                }
                self?.movieTrailersRelay.accept(viewModelArr)
            })
            .disposed(by: bag)
    }
}
