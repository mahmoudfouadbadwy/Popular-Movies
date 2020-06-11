//
//  Home.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class Home: UIViewController {
    @IBOutlet weak var connectivity: UIBarButtonItem!
    @IBOutlet weak var homeTitle: UIBarButtonItem!
    @IBOutlet weak var collection: UICollectionView!
    var popMovies:[NSManagedObject]=[]
    var index:Int = -1
    // Menu Variables
    let cellId = "cell"
    var blackView:UIView!
    var collectionMenu:UICollectionView!
    let homeVM:MoviesStore = MoviesStore(moviesData:MoviesDataAccess())
    let localHomeVM:MoviesStore = MoviesStore(coreData: CoreData())
    var movies:[HomeVM] = []{
        didSet{
            self.collection.reloadData()
        }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        setupMoviesCollection()
        setupCollectionMenu()
        connectivity.image = UIImage.init(named: "connection")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Networking.checkNetwork()
        {
            homeVM.getmovies(by:Constants.moviesUrl, appendFlag: 1, completion: { [weak self](results) in
                self?.movies = results
            })
            connectivity.tintColor = UIColor.green
        }
        else
        {
            movies = localHomeVM.getLocalMovies()
            connectivity.tintColor = UIColor.red
        }
        // observer
        ReachabilityManager.shared.addListener(listener: self as NetworkStatusListener)
    }
    
    @IBAction func menuClick(_ sender: Any) {
        showMenu()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // observer
        ReachabilityManager.shared.removeListener(listener: self as NetworkStatusListener)
    }

    //    // segue preparation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let detail:MovieDetail = segue.destination as! MovieDetail
    //        // connected to network
    //        if network.checkNetwork()
    //        {
    //            if movies.count != 0   // avoiding first run without network then  network become availabel and movies = 0
    //            {
    //                if let fname = (movies[index]["original_title"]) as? String
    //                {
    //                 detail.filmName = fname
    //                }
    //                if let fimage:String = (movies[index]["poster_path"]) as? String
    //                {
    //                 detail.filmImage = fimage
    //                }
    //
    //                if let  frelease = (movies[index]["release_date"]) as? String
    //                {
    //                     detail.filmRelease = frelease
    //                }
    //
    //                if let foverview = (movies[index]["overview"]) as? String
    //                {
    //                 detail.filmOverView = foverview
    //                }
    //                if let frate = (movies[index]["vote_average"]) as? Double
    //                {
    //                 detail.filmRate = frate
    //                }
    //
    //                if let fid = (movies[index]["id"]) as? Double
    //                {
    //                    detail.filmId = fid
    //                }
    //            }
    //        }
    //         // not connected to network
    //        else
    //        {     // for first open  // avoid empty core data
    //         if (localMovies.count != 0)
    //         {
    //            if let fname = (localMovies[index].value(forKey: "name")) as? String
    //            {
    //                detail.filmName = fname
    //            }
    //            if let fimage:String = (localMovies[index].value(forKey: "image")) as? String
    //            {
    //                detail.filmImage = fimage
    //            }
    //
    //            if let  frelease = (localMovies[index].value(forKey: "frelease")) as? String
    //            {
    //                detail.filmRelease = frelease
    //            }
    //
    //            if let foverview = (localMovies[index].value(forKey: "overview")) as? String
    //            {
    //                detail.filmOverView = foverview
    //            }
    //            if let frate = (localMovies[index].value(forKey: "frate")) as? Double
    //            {
    //                detail.filmRate = frate
    //            }
    //
    //            if let fid = (localMovies[index].value(forKey: "id")) as? Double
    //            {
    //                detail.filmId = fid
    //            }
    //           }
    //        }
    //    }
    
    
}
