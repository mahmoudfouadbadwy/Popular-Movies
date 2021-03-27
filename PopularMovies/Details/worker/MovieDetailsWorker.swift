//
//  MovieDetailsWorker.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/21/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import Foundation
import RxSwift

class MovieDetailsWorker {
    
    static func getMovieDetails(by id: Int)-> Observable<MovieDetailsData.Response> {
        let url = Constants.movieDetailsPath + "\(id)" + Constants.movieDetailsPath2
        return WebService.makeRequest(requestUrl: url)
    }
    
    static func getReviews(by id: Int) -> Observable<Review.Response> {
        let url = Constants.reviewPath + "\(id)" + Constants.reviewPath2
        return WebService.makeRequest(requestUrl: url)
    }
    
    static func getTrailers(by id: Int) -> Observable<Trailer.Response> {
        let url = Constants.movieTrailerPath + "\(id)" + Constants.movieTrailerPath2
        return WebService.makeRequest(requestUrl: url)
    }
}
