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
        let url = Strings.URL.movieDetailsPath + "\(id)" + Strings.URL.movieDetailsPath2
        return WebService.makeRequest(requestUrl: url)
    }
    
    static func getReviews(by id: Int) -> Observable<Review.Response> {
        let url = Strings.URL.reviewPath + "\(id)" + Strings.URL.reviewPath2
        return WebService.makeRequest(requestUrl: url)
    }
    
    static func getTrailers(by id: Int) -> Observable<Trailer.Response> {
        let url = Strings.URL.movieTrailerPath + "\(id)" + Strings.URL.movieTrailerPath2
        return WebService.makeRequest(requestUrl: url)
    }
}
