//
//  Home.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import SDWebImage

class Home: UIViewController {
    @IBOutlet weak var connectivity: UIBarButtonItem!
    @IBOutlet weak var homeTitle: UIBarButtonItem!
    @IBOutlet weak var collection: UICollectionView!
    var index:IndexPath!
    let cellId = "cell"
    var blackView:UIView!
    var collectionMenu:UICollectionView!
    let homeVM:MoviesStore = MoviesStore(moviesData:MoviesDataAccess())
    let localHomeVM:MoviesStore = MoviesStore(coreData: CoreData())
    var indicator:UIActivityIndicatorView!
    var movies:[HomeVM] = []{
        didSet{
            self.collection.reloadData()
        }
    }
    var popMovies:[HomeVM]=[]{
        didSet{
            self.collection.reloadData()
        }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        setupMoviesCollection()
        setupCollectionMenu()
        connectivity.image = UIImage.init(named: "connection")
        indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Networking.checkNetwork()
        {
            indicator.startAnimating()
            homeVM.getmovies(by:Constants.moviesUrl, appendFlag: 1, completion: { [weak self](results) in
                self?.movies = results
                self?.indicator.stopAnimating()
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

        // segue preparation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let detail:MovieDetailsController = segue.destination as! MovieDetailsController
            detail.filmId = movies[index.row].id
        }
    
}
