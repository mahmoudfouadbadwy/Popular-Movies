//
//  Home.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import SDWebImage
import AFNetworking
import CoreData
import ReachabilitySwift
// observer
extension Home: NetworkStatusListener {
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        switch status {
        case .notReachable:
            DispatchQueue.main.async {
              //  self.disableInteractiveElements()
                print("not reachable")
                self.connectivity.tintColor = UIColor.red
                self.collection.reloadData()
                
            }
        case .reachableViaWiFi:
            DispatchQueue.main.async {
              //  self.enableInteractiveElements()
                 print(" reachable wifi")
                self.connectivity.tintColor = UIColor.green
                self.getApiData(url:"http://api.themoviedb.org/3/discover/movie?api_key=d52a9c41632a8b38d8c0dd5b5652b937",appendFalg: 0)
               
            }
        case .reachableViaWWAN:
            DispatchQueue.main.async {
              //  self.enableInteractiveElements()
                self.connectivity.tintColor = UIColor.green
            }
        }
    }
}


class Home: UIViewController {
    @IBOutlet weak var connectivity: UIBarButtonItem!
    @IBOutlet weak var homeTitle: UIBarButtonItem!
    @IBOutlet weak var collection: UICollectionView!
    var movies:[Dictionary<String,Any>] = []
    var localMovies:[NSManagedObject]=[]
    var popMovies:[NSManagedObject]=[]
    var imagePath:String = "http://image.tmdb.org/t/p/w185/"
    let api = API()
    var index:Int = -1
    let network = NetworkModel()
    let coredata = CoreData()
    // Menu Variables
    let cellId = "cell"
    var blackView:UIView!
    var collectionMenu:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoviesCollection()
        setupCollectionMenu()
        localMovies = coredata.getFromMovies()
        self.collection.reloadData()
        connectivity.image = UIImage.init(named: "connection")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if network.checkNetwork()
        {
            getApiData(url:"http://api.themoviedb.org/3/discover/movie?api_key=d52a9c41632a8b38d8c0dd5b5652b937",appendFalg: 1)
            connectivity.tintColor = UIColor.green
        }
        else
        {
            connectivity.tintColor = UIColor.red
        }
        // observer
        ReachabilityManager.shared.addListener(listener: self as NetworkStatusListener)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // observer
        ReachabilityManager.shared.removeListener(listener: self as NetworkStatusListener)
    }
    
    // segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail:MovieDetail = segue.destination as! MovieDetail
        // connected to network
        if network.checkNetwork()
        {
            if movies.count != 0   // avoiding first run without network then  network become availabel and movies = 0
            {
                if let fname = (movies[index]["original_title"]) as? String
                {
                 detail.filmName = fname
                }
                if let fimage:String = (movies[index]["poster_path"]) as? String
                {
                 detail.filmImage = fimage
                }
                
                if let  frelease = (movies[index]["release_date"]) as? String
                {
                     detail.filmRelease = frelease
                }
               
                if let foverview = (movies[index]["overview"]) as? String
                {
                 detail.filmOverView = foverview
                }
                if let frate = (movies[index]["vote_average"]) as? Double
                {
                 detail.filmRate = frate
                }
                
                if let fid = (movies[index]["id"]) as? Double
                {
                    detail.filmId = fid
                }
            }
        }
         // not connected to network
        else
        {     // for first open  // avoid empty core data
         if (localMovies.count != 0)
         {
            if let fname = (localMovies[index].value(forKey: "name")) as? String
            {
                detail.filmName = fname
            }
            if let fimage:String = (localMovies[index].value(forKey: "image")) as? String
            {
                detail.filmImage = fimage
            }
            
            if let  frelease = (localMovies[index].value(forKey: "frelease")) as? String
            {
                detail.filmRelease = frelease
            }
            
            if let foverview = (localMovies[index].value(forKey: "overview")) as? String
            {
                detail.filmOverView = foverview
            }
            if let frate = (localMovies[index].value(forKey: "frate")) as? Double
            {
                detail.filmRate = frate
            }
            
            if let fid = (localMovies[index].value(forKey: "id")) as? Double
            {
                detail.filmId = fid
            }
           }
        }
    }
 
    // get data from api
    func getApiData(url: String , appendFalg:Int)
    {
        api.getdata(url:url,appendFlag: appendFalg ) { (result) in
            self.movies = result
            self.collection.reloadData()
        }
    }

    // menubutton action
    @IBAction func menuClick(_ sender: Any) {
        showMenu()
    }
}
