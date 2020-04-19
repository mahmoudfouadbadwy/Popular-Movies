//
//  Fav.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/6/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
class Fav: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var favCollection: UICollectionView!
    let core:CoreData = CoreData()
    var movies:[NSManagedObject]=[]
    let imagePath:String = "http://image.tmdb.org/t/p/w185/"
    var index:Int = -1
    let network:NetworkModel = NetworkModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        favCollection.delegate = self
        favCollection.dataSource = self 
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       movies = core.getFavouriteMovies()
       favCollection.reloadData()
     
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FavouriteCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "favouriteCell", for: indexPath) as! FavouriteCell)
        if movies.count != 0
        {
            if let path = (movies[indexPath.row].value(forKey: "image") as? String)
            {
                
                cell.favouriteImage.sd_setImage(with: URL(string: imagePath+path), completed: nil)
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.size.width/2, height: CGFloat(collectionView.bounds.size.height/2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        index = indexPath.row
        performSegue(withIdentifier: "favDetails", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail:MovieDetail = segue.destination as! MovieDetail
        
            if let fname = (movies[index].value(forKey: "name")) as? String
            {
                detail.filmName = fname
            }
            if let fimage:String = (movies[index].value(forKey: "image")) as? String
            {
                detail.filmImage = fimage
            }
            
            if let  frelease = (movies[index].value(forKey: "frelease")) as? String
            {
                detail.filmRelease = frelease
            }
            
            if let foverview = (movies[index].value(forKey: "overview")) as? String
            {
                detail.filmOverView = foverview
            }
            if let frate = (movies[index].value(forKey: "frate")) as? Double
            {
                detail.filmRate = frate
            }
            
            if let fid = (movies[index].value(forKey: "id")) as? Double
            {
                detail.filmId = fid
            }   
        
    }
}
