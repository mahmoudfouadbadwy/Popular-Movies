//
//  DetailsVM.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/19/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation

class MovieDetailsVM{
    var movieDetailsAccess:MovieDetailsData!
    var movieDetails:MovieDetails!
    init(movieDetailsAccess:MovieDetailsData) {
         self.movieDetailsAccess = movieDetailsAccess
    }
    func getMovieDetails(by id:Int,completion:@escaping(MovieDetails)->Void){
        movieDetailsAccess.getMovieDetailsData(url:"\(Constants.movieDetailsPath)\(id)\(Constants.movieDetailsPath2)") { (result) in
            self.movieDetails = MovieDetails(movie: result)
            completion(self.movieDetails)
        }
    }
    
    func getMovieTrailers(url:String,completion:@escaping([Dictionary<String,Any>])->Void){
        movieDetailsAccess.getMovieTrailers(url: url) { (result) in
            completion(result)
        }
    }
    
    func getMovieReviews(url:String,completion:@escaping([Dictionary<String,Any>])->Void)
    {
        movieDetailsAccess.getMovieReviews(url: url) { (result) in
             completion(result)
        }
    }
}

class MovieCoreVM{
    var coreData:LocalStorage!
    var movie:MoviesData.Movie!
    init(movieCoreData:LocalStorage) {
        self.coreData = movieCoreData
    }
    func checkIsFavoriteMovie(movieID:Int)->Int{
        return coreData.checkIsFavourite(id: movieID)
    }
    
    func addToFavorite(movieID:Int,movie:MovieDetails){
//        self.movie = Movie(id: movieID, originalTitle: movie.title, overview: movie.overview, posterPath: movie.poster, voteAverage: movie.rate, releaseDate: movie.release)
//        coreData.addToFavourite(movie: self.movie)
    }
    func deleteFromFavorite(movieID:Int){
        self.coreData.deleteFromFavourite(id: movieID)
    }
}

struct MovieDetails{
    var title:String
    var poster:String
    var rate:Double
    var overview:String
    var release:String
    init(movie:MoviesData.Movie)
    {
        self.title = movie.title
        self.poster = movie.posterPath
        self.rate = movie.voteAverage
        self.overview = movie.overview
        self.release = movie.releaseDate
    }
}
