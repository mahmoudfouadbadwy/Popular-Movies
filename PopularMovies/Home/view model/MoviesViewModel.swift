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
    func getMoviesIn(page: Int)
    func getPopularMovies()
    func getTopRatedMoviesIn(page: Int)
    func getTopRatedMovies()
    func getMoviesInNext(page: Int)
    
}

class MoviesViewModel: MoviesBusiness {
    
    var isPopularMovies = true
    var movies: BehaviorRelay<[MovieViewModel]> = BehaviorRelay(value: [])
    private let bag = DisposeBag()
    
    func getMoviesIn(page: Int)
    {
        MoviesWorker
            .getMovies(page: page)
            .subscribe(onNext: {[weak self] movies in
                let moviesViewModel = movies.map { movie in
                    MovieViewModel(moviePoster: movie.posterPath,
                                   id: movie.id, originalTitle: movie.originalTitle,
                                   overview: movie.overview, voteAverage: movie.voteAverage,
                                   releaseDate: movie.releaseDate)
                }
                self?.movies.accept(moviesViewModel)
            })
            .disposed(by: bag)
    }
    
    func getPopularMovies() {
        if Networking.isNetworkEnabled() {
            getMoviesIn(page: 1)
        } else {
            
        }
    }
    
    func getTopRatedMovies() {
        if Networking.isNetworkEnabled() {
            getTopRatedMoviesIn(page: 1)
        } else {
            
        }
    }
    
    func getTopRatedMoviesIn(page: Int) {
        MoviesWorker
            .getTopMovies(page: page)
            .subscribe(onNext: {[weak self] movies in
                let moviesViewModel = movies.map { movie in
                    MovieViewModel(moviePoster: movie.posterPath,
                                   id: movie.id, originalTitle: movie.originalTitle,
                                   overview: movie.overview, voteAverage: movie.voteAverage,
                                   releaseDate: movie.releaseDate)
                }
                self?.movies.accept(moviesViewModel)
            })
            .disposed(by: bag)
    }
    
    func getMoviesInNext(page: Int) {
        isPopularMovies ? getMoviesIn(page: page) : getTopRatedMoviesIn(page: page)
    }
    
    
    //    func getLocalMovies()-> [HomeVM]
    //    {
    //     return coreData.getFromMovies().map { (result) in
    //            movie = Movie(id: result.value(forKey: "id") as? Int ?? 0, originalTitle: result.value(forKey: "name") as? String ?? "", overview: result.value(forKey: "overview") as? String ?? "", posterPath: result.value(forKey: "image") as? String ?? "", voteAverage: result.value(forKey: "frate") as? Double ?? 0.0, releaseDate: result.value(forKey: "frelease") as? String ?? "")
    //  return HomeVM(movie: movie)
    //     }
    //  }
    
//    func addMovieTolocalStorage(id:Int,name:String,overview:String,image:String,rate:Double,release:String)
//    {
//                let movie:Movie = Movie(id: id, originalTitle: name, overview: overview, posterPath: image, voteAverage: rate, releaseDate: release)
//         coreData.addToStorage(mov: movie, flag: 0)
//    }
}




