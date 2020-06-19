//
//  MovieDetail.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import AFNetworking
class MovieDetailsController: UIViewController {
    @IBOutlet weak var youtubeCollection: UICollectionView!
    @IBOutlet weak var reviewsCollection: UICollectionView!
    @IBOutlet weak var cosmosview: CosmosView!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var MovieDate: UILabel!
    @IBOutlet weak var MovieFav: UIButton!
    var filmId:Int!
    var trailers:[Dictionary<String,Any>] = []
    var reviewsArr:[Dictionary<String,Any>] = []
    var movie:MovieDetails!
    var movieDetailsVM:MovieDetailsVM!
    var movieData:MovieDetailsData!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        self.movieData = MovieDetailsData()
        self.movieDetailsVM = MovieDetailsVM(movieDetailsAccess: movieData)
        self.movieDetailsVM.getMovieDetails(by: filmId) { (result) in
            self.movie = result
            self.bindDetails()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  core = CoreData()
     //   core?.setId(id: filmId)
        
//        if core?.checkIsFavourite(id: filmId) != 0
//        {
//            MovieFav.tintColor = UIColor.red
//        }
        if Networking.checkNetwork()
        {
          //  bindDetails()
            // reviews
       //     showReviews()
            // trailers
       //     shwoTrailers()
            
        }
        

    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func makeFavourite(_ sender: UIButton) {
        // make favourite
        if (MovieFav.tintColor == UIColor.white)
        {
            MovieFav.tintColor = UIColor.red
//            core?.addToFavourite(name: filmName, overview: filmOverView, image: filmImage, rate: filmRate, release: filmRelease,flag: 1)
        }
        else{  // delete from favourite
            MovieFav.tintColor = UIColor.white
        //    core?.deleteFromFavourite(id: filmId)
        }
    }

//    func shwoTrailers()
//    {
//        
//        api.getMoviesData(url: "https://api.themoviedb.org/3/movie/"+String(filmId)+"/videos?api_key=d52a9c41632a8b38d8c0dd5b5652b937&language=en-US",appendFlag: 0) { (result) in
//            self.trailers = result
//            self.youtubeCollection.reloadData()
//            
//        }
//        
//    }
    
    func openTrailerOnYoutube(key:String)
        
    {
        var url = URL(string :"youtube://\(key)")!
        if  !UIApplication.shared.canOpenURL(url)
        {
            url = URL(string: "https://www.youtube.com/watch?v=\(key)")!  // youtube app on phone
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)  // youtube on browser
        
    }
    
//    func showReviews()
//    {
//        api.getMoviesData(url: reviewPath+String(filmId)+reviewPath2,appendFlag: 0) { (result) in
//            self.reviewsArr = result
//            self.reviewsCollection.reloadData()
//        }
//    }
}
