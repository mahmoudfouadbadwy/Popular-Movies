//
//  Movie.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/10/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation

struct Movie{
    let popularity: Double
    let voteCount: Int
    let posterPath: String
    let id: Int
    let originalTitle: String
    let title: String
    let voteAverage: Double
    let overview:String
    let releaseDate: String
    
    init(popularity: Double,voteCount: Int,posterPath: String,id: Int,originalTitle: String,title: String,voteAverage: Double,overview:String, releaseDate: String) {
        self.popularity = popularity
        self.voteCount = voteCount
        self.posterPath = posterPath
        self.id = id
        self.originalTitle = originalTitle
        self.title = title
        self.voteAverage = voteAverage
        self.overview = overview
        self.releaseDate = releaseDate
    }
    
    init(id:Int,originalTitle: String,overview:String,posterPath: String,voteAverage: Double,releaseDate: String) {
        self.init(popularity: 0.0, voteCount: 0, posterPath: posterPath, id: id, originalTitle: originalTitle, title: "", voteAverage: voteAverage, overview: overview, releaseDate: releaseDate)
    }
}
