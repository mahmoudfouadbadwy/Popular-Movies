//
//  FavoriteVM.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/23/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoriteBusiness {
    var movies: BehaviorRelay<[MoviesData.ViewModel]>{ get }
    func getFavoriteMovies()
}

class FavoriteViewModel: FavoriteBusiness {
    
    var movies: BehaviorRelay<[MoviesData.ViewModel]> = BehaviorRelay(value: [])
    private let storage = LocalStorage.shared
    
    func getFavoriteMovies() {
        let favoriteMovies = storage.getFavouriteMovies().map { (movie)  in
            MoviesData.ViewModel(moviePoster: movie.value(forKey: "poster") as! String,
                                 id: movie.value(forKey: "id") as! Int,
                                 originalTitle: movie.value(forKey: "name") as! String,
                                 overview: movie.value(forKey: "overview") as! String,
                                 voteAverage: movie.value(forKey: "rate") as! Double,
                                 releaseDate: movie.value(forKey: "mRelease") as! String)
        }
        movies.accept(favoriteMovies)
    }
}


