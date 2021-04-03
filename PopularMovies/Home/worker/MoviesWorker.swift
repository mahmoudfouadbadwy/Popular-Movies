//
//  MoviesWorker.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/11/21.
//  Copyright © 2021 Mahmoud Fouad. All rights reserved.
//

import Foundation
import RxSwift

class MoviesWorker {
    
    static func getMovies(page: Int) -> Observable<MoviesData.Response> {
        return WebService.makeRequest(requestUrl: "\(Strings.URL.moviesUrl)&page=\(page)")
    }
    
    static func getTopMovies(page: Int) -> Observable<MoviesData.Response> {
        return WebService.makeRequest(requestUrl: "\(Strings.URL.moviesTopRate)&page=\(page)")
    }

}
