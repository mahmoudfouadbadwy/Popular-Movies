//
//  MoviesWorker.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/11/21.
//  Copyright © 2021 Mahmoud Fouad. All rights reserved.
//

import Foundation
import Combine


protocol WorkerBusinessLogic {
    func getMovies(page: Int) -> AnyPublisher<MoviesData.Response, Exception>
    func getTopMovies(page: Int) -> AnyPublisher<MoviesData.Response, Exception>
}


class MoviesWorker: WorkerBusinessLogic {
    private let webService = WebService()
    func getMovies(page: Int) -> AnyPublisher<MoviesData.Response, Exception> {
        webService.makeRequest(url: "\(Strings.URL.moviesUrl)&page=\(page)")
    }
    
    func getTopMovies(page: Int) -> AnyPublisher<MoviesData.Response, Exception> {
        webService.makeRequest(url: "\(Strings.URL.moviesTopRate)&page=\(page)")
    }
}
