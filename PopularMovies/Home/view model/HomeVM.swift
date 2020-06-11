//
//  HomeVM.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/11/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
import ReachabilitySwift
struct HomeVM{
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
    
    init(poster:String)
    {
        self.moviePoster = poster
    }
}

class MoviesStore{
    private  var movies:[HomeVM]!
    private  var moviesData:MoviesDataAccess!
    private  var coreData:CoreData!
    init(moviesData:MoviesDataAccess) {
        self.moviesData = moviesData
    }
    func getmovies(by url:String,appendFlag:Int,completion:@escaping([HomeVM])->Void)
    {
        moviesData.getMoviesData(url:url, appendFlag:appendFlag) {[weak self] (result) in
            self?.movies = result.map({
                movie in
                return HomeVM(movie: movie)
            })
            completion(self?.movies ?? [])
        }
    }
    
    init(coreData:CoreData){
        self.coreData =  coreData
    }
    
    func getLocalMovies()-> [HomeVM]
    {
        return coreData.getFromMovies().map { (result)  in
            HomeVM(poster: result.value(forKey: "image") as? String ?? "")
        }
    }
    
    func addMovieTolocalStorage(id:Int,name:String,overview:String,image:String,rate:Double,release:String)
    {
        let movie:Movie = Movie(id: id, originalTitle: name, overview: overview, posterPath: image, voteAverage: rate, releaseDate: release)
        coreData.addToStorage(mov: movie, flag: 0)
    }
}

struct Networking{
    static func checkNetwork()->Bool {
        let reachability =  Reachability()
        if (reachability?.isReachable)!{
            return true
        }
        else
        {
            return false
        }
    }
}



