//
//  MoviesWorker.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/11/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import Foundation
import RxSwift

class MoviesWorker {
    
    static func getMovies(page: Int) -> Observable<[Movie]> {
        return MoviesService.loadData(requestUrl:  "\(Constants.moviesUrl)&page=\(page)" )
    }
    
    static func getTopMovies(page: Int) -> Observable<[Movie]> {
        return MoviesService.loadData(requestUrl: "\(Constants.moviesTopRate)&page=\(page)")
    }

}
