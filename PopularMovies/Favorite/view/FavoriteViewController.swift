//
//  Fav.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/6/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteViewController: UIViewController{
    @IBOutlet weak var favCollection: UICollectionView!
    var coreData:CoreData!
    var favVM:FavoriteVM!
    var index:Int = -1
    var movies:[Favorite]=[]{
        didSet{
            self.favCollection.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favCollection.delegate = self
        favCollection.dataSource = self
        self.coreData = CoreData()
        self.favVM = FavoriteVM(coreDate: coreData)
    }
    override func viewWillAppear(_ animated: Bool) {
       movies = favVM.getFavorites()
     
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail:MovieDetailsController = segue.destination as! MovieDetailsController
         detail.filmId = movies[index].id
    }
}
