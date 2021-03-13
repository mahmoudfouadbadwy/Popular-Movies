//
//  Constants.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/11/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation

struct Constants {
    
    static let imagePath = "http://image.tmdb.org/t/p/w185/"
    static let moviesUrl = "http://api.themoviedb.org/3/discover/movie?api_key=d52a9c41632a8b38d8c0dd5b5652b937"
    static let moviesTopRate = "http://api.themoviedb.org/3/discover/movie?sort_by=vote_count.desc&api_key=d52a9c41632a8b38d8c0dd5b5652b937"
    static let reviewPath = "https://api.themoviedb.org/3/movie/"
    static let reviewPath2 = "/reviews?api_key=d52a9c41632a8b38d8c0dd5b5652b937"
    static let movieDetailsPath = "https://api.themoviedb.org/3/movie/"
    static let movieDetailsPath2 = "?api_key=d52a9c41632a8b38d8c0dd5b5652b937&language=en-US"
    static let movieTrailerPath  = "https://api.themoviedb.org/3/movie/"
    static let movieTrailerPath2 = "/videos?api_key=d52a9c41632a8b38d8c0dd5b5652b937&language=en-US"
}


