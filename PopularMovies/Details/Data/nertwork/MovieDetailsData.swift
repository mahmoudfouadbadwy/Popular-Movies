//
//  MovieDetailsData.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/19/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import AFNetworking
class MovieDetailsData{
    var movie:MoviesData.Movie!
    func getMovieDetailsData(url:String,completion:@escaping(MoviesData.Movie)-> Void)
    {
        let manager = AFHTTPSessionManager()
        manager.get(
            url,
            parameters: nil,
            success:
            {[weak self]
                (operation, responseObject) in
                let result:Dictionary<String,Any> = responseObject as! Dictionary<String,Any>
//                self?.movie = Movie(popularity:result["popularity"] as! Double, voteCount: result["vote_count"] as! Int, posterPath: result["poster_path"] as! String, id: result["id"] as! Int, originalTitle: result["original_title"] as! String, title: result["title"] as! String, voteAverage: result["vote_average"] as! Double, overview: result["overview"] as! String, releaseDate: result["release_date"] as! String)
                completion(self!.movie)
            },
            failure:
            {
                (operation, error) in
                print(error)
        })
        
    }
    
    
    func getMovieTrailers(url:String,completion:@escaping([Dictionary<String,Any>])->Void){
        let manager = AFHTTPSessionManager()
        manager.get(
            url,
            parameters: nil,
            success:
            {
                (operation, responseObject) in
                let result:Dictionary<String,Any> = responseObject as! Dictionary<String, Any>
                completion(result["results"] as! [Dictionary<String, Any>])
            },
            failure:
            {
                (operation, error) in
                print(error)
        })
    }
    
    func getMovieReviews(url:String,completion:@escaping([Dictionary<String,Any>])->Void){
        let manager = AFHTTPSessionManager()
        manager.get(
            url,
            parameters: nil,
            success:
            {
                (operation, responseObject) in
                let result:Dictionary<String,Any> = responseObject as! Dictionary<String, Any>
                completion(result["results"] as! [Dictionary<String, Any>])
        },
            failure:
            {
                (operation, error) in
                print(error)
        })
    }
}


