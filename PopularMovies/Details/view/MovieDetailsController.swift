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
class MovieDetailsController: UIViewController {
    @IBOutlet weak var youtubeCollection: UICollectionView!
    @IBOutlet weak var reviewsCollection: UICollectionView!
    @IBOutlet weak var cosmosview: CosmosView!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var favButton: UIButton!
    var filmId:Int!
    var movie:MovieDetails!
    var movieDetailsVM:MovieDetailsVM!
    var movieData:MovieDetailsData!
    var movieCore:CoreData!
    var movieCoreVM:MovieCoreVM!
    var trailers:[Dictionary<String,Any>]!=[] {
        didSet{
            self.youtubeCollection.reloadData()
        }
    }
    var reviewsArr:[Dictionary<String,Any>]! = []{
        didSet{
            self.reviewsCollection.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        self.movieData = MovieDetailsData()
        self.movieDetailsVM = MovieDetailsVM(movieDetailsAccess: movieData)
        self.movieDetailsVM.getMovieDetails(by: filmId) { (result) in
            self.movie = result
            self.bindDetails()
        }
        self.movieCore = CoreData()
        self.movieCoreVM = MovieCoreVM(movieCoreData: movieCore)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Networking.isNetworkEnabled()
        {
            showReviews()
            shwoTrailers()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeFavourite(_ sender: UIButton) {
        if (favButton.tintColor == UIColor.white)
        {
            favButton.tintColor = UIColor.red
            movieCoreVM.addToFavorite(movieID: filmId, movie: movie)
        }
        else
        {
            favButton.tintColor = UIColor.white
            movieCoreVM.deleteFromFavorite(movieID: filmId)
        }
    }
    
    func shwoTrailers()
    {
        movieDetailsVM.getMovieTrailers(url: Constants.movieTrailerPath+String(filmId)+Constants.movieTrailerPath2) { (result) in
            self.trailers = result
        }
    }
    
    func openTrailerOnYoutube(key:String)
        
    {
        var url = URL(string :"youtube://\(key)")!
        if  !UIApplication.shared.canOpenURL(url)
        {
            url = URL(string: "https://www.youtube.com/watch?v=\(key)")!  // youtube app on phone
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)  // youtube on browser
    }
    
    func showReviews()
    {
        
        movieDetailsVM.getMovieReviews(url: Constants.reviewPath+String(filmId)+Constants.reviewPath2) { (result) in
            self.reviewsArr = result
        }
        
    }
}
