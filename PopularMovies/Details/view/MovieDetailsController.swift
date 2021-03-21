//
//  MovieDetail.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos


class MovieDetailsController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak fileprivate var youtubeCollection: UICollectionView!
    @IBOutlet weak private var reviewsCollection: UICollectionView!
    @IBOutlet weak private var cosmosView: CosmosView!
    @IBOutlet weak private var movieOverview: UITextView!
    @IBOutlet weak private var movieName: UILabel!
    @IBOutlet weak private var movieImage: UIImageView!
    @IBOutlet weak private var movieDate: UILabel!
    @IBOutlet weak private var favButton: UIButton!
    
    //MARK:- Properties
    var movieID: Int!
    var movie: MovieDetails!
    var movieDetailsVM: MovieDetailsVM!
    var movieData: MovieDetailsData!
    var movieCore: LocalStorage!
    var movieCoreVM: MovieCoreVM!
    var trailers: [Dictionary<String,Any>]!=[] {
        didSet{
            self.youtubeCollection.reloadData()
        }
    }
    var reviewsArr: [Dictionary<String,Any>]! = []{
        didSet{
            self.reviewsCollection.reloadData()
        }
    }
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        //        self.movieData = MovieDetailsData()
        //        self.movieDetailsVM = MovieDetailsVM(movieDetailsAccess: movieData)
        //        self.movieDetailsVM.getMovieDetails(by: filmId) { (result) in
        //            self.movie = result
        //            self.bindDetails()
        //        }
        //        self.movieCore = LocalStorage()
        //        self.movieCoreVM = MovieCoreVM(movieCoreData: movieCore)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        if Networking.isNetworkEnabled
        //        {
        //            showReviews()
        //            shwoTrailers()
        //        }
    }
    
    @IBAction func makeFavourite(_ sender: UIButton) {
        if (favButton.tintColor == UIColor.white)
        {
            favButton.tintColor = UIColor.red
            movieCoreVM.addToFavorite(movieID: movieID, movie: movie)
        }
        else
        {
            favButton.tintColor = UIColor.white
            movieCoreVM.deleteFromFavorite(movieID: movieID)
        }
    }
    
    
    func setupCollections(){
        youtubeCollection.delegate = self
        youtubeCollection.dataSource = self
        reviewsCollection.delegate = self
        reviewsCollection.dataSource = self
    }
    
    func bindDetails()
    {
        movieName.text = self.movie.title
        movieImage!.sd_setImage(with:URL(string:Constants.imagePath+self.movie.poster),completed: nil)
        movieOverview.text = self.movie.overview
        movieDate.text = self.movie.release
        cosmosView.settings.fillMode = .precise
        cosmosView.rating = (self.movie.rate) / 2.0
        cosmosView.isUserInteractionEnabled = false
        if self.movieCoreVM.checkIsFavoriteMovie(movieID: movieID) != 0
        {
            favButton.tintColor = UIColor.red
        }
    }
    func shwoTrailers()
    {
        movieDetailsVM.getMovieTrailers(url: Constants.movieTrailerPath+String(movieID)+Constants.movieTrailerPath2) { (result) in
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
        
        movieDetailsVM.getMovieReviews(url: Constants.reviewPath+String(movieID)+Constants.reviewPath2) { (result) in
            self.reviewsArr = result
        }
        
    }
}
