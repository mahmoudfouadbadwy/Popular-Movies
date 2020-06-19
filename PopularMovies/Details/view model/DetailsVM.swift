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
}

struct MovieDetails{
    var title:String
    var poster:String
    var rate:Double
    var overview:String
    var release:String
    init(movie:Movie)
    {
        self.title = movie.title
        self.poster = movie.posterPath
        self.rate = movie.voteAverage
        self.overview = movie.overview
        self.release = movie.releaseDate
    }
}
