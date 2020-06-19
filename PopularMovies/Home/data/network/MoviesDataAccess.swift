//
//  API.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import AFNetworking
class MoviesDataAccess{
    var movies:[Movie] = []
    func getMoviesData(url:String,appendFlag:Int,completion:@escaping([Movie])-> Void)
    {
        let manager = AFHTTPSessionManager()
        manager.get(
            url,
            parameters: nil,
            success:
            {[weak self]
                (operation, responseObject) in
                let results:Dictionary<String,Any> = responseObject as! Dictionary<String,Any>
                let allMovies = results["results"]  as! [Dictionary<String,Any>]
                if appendFlag == 0
                {
                    self?.movies=[]
                }
                for i in 0..<allMovies.count
                {
                    let movie = allMovies[i]
                    self?.movies.append(Movie(popularity: movie["popularity"] as? Double ?? 0.0, voteCount: movie["vote_count"] as? Int ?? 0, posterPath:movie["poster_path"] as? String ?? "", id: movie["id"] as? Int ?? 0, originalTitle: movie["original_title"] as? String ?? "", title: movie["title"] as? String ?? "", voteAverage: movie["vote_average"] as? Double ?? 0.0, overview: movie["overview"] as? String ?? "", releaseDate: movie["release_date"] as? String ?? ""))
                }
                completion(self?.movies ?? [])
        },
            failure:
            {
                (operation, error) in
                completion([])
        })
        
    }
}

