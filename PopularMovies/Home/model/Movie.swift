//
//  Movie.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/10/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import Foundation


enum MoviesData {
    
    struct Request { }
    
    struct Response: Codable {
        let page: Int
        let movies: [Movie]
        let totalPages, totalResults: Int
        
        enum CodingKeys: String, CodingKey {
            case page
            case movies = "results"
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }
    
    struct Movie: Codable {
        let adult: Bool
        let backdropPath: String?
        let genreIDS: [Int]
        let id: Int
        let originalLanguage, originalTitle, overview: String
        let popularity: Double
        let posterPath, releaseDate, title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int
        
        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIDS = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
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
