//
//  MovieDetialsData.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/21/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import Foundation

enum MovieDetailsData {
    struct Request {}
    struct Response: Codable {
        var id: Int
        var originalTitle, overview: String
        var posterPath: String
        var releaseDate: String
        var voteAverage: Double
        
        enum CodingKeys: String, CodingKey {
            case id
            case originalTitle = "original_title"
            case overview
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
        }
    }
    
    static var fakeMovie: ViewModel {
        ViewModel(moviePoster: "",
                  id: 1,
                  originalTitle: "",
                  overview: "No overview available",
                  voteAverage: 0.0,
                  releaseDate: "0000-00-00")
    }
    
    struct ViewModel {
        var moviePoster: String
        var id: Int
        var originalTitle: String
        var overview: String
        var voteAverage: Double
        var releaseDate: String
    }
}
