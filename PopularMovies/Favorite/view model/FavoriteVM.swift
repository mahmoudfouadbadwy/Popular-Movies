//
//  FavoriteVM.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/23/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation

class FavoriteVM{
    var coreData:CoreData!
    var movie:Movie!
    init(coreDate:CoreData!) {
        self.coreData = coreDate
    }
    
    func getFavorites()->[Favorite]
    {
     return coreData.getFavouriteMovies().map {[weak self] (result)  in
            self?.movie = Movie(id: result.value(forKey: "id") as? Int ?? 0, originalTitle: result.value(forKey: "name") as? String ?? "", overview: result.value(forKey: "overview") as? String ?? "", posterPath: result.value(forKey: "image") as? String ?? "", voteAverage: result.value(forKey: "frate") as? Double ?? 0.0, releaseDate: result.value(forKey: "frelease") as? String ?? "")
            return Favorite(movie: movie)
        }
    }
    
}

struct Favorite{
    var moviePoster:String!
    var id:Int!
    var originalTitle: String!
    var overview: String!
    var voteAverage: Double!
    var releaseDate: String!
    init(movie:Movie) {
        self.moviePoster = movie.posterPath
        self.id = movie.id
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.voteAverage = movie.voteAverage
        self.releaseDate = movie.releaseDate
    }
}


