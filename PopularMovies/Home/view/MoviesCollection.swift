//
//  MoviesCollection.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/7/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit

extension Home{
    func setupMoviesCollection()
    {
        // movies collection
        collection.delegate = self
        collection.dataSource = self
    }
}

extension Home: UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0  // films collection
        {
            if network.checkNetwork(){  // connected to network
                return movies.count
            }
            else{  // not connected
                return localMovies.count
            }
        }
        else
        {
            return 2   // menu collection
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // film collection
        if collectionView.tag == 0
        {
            let cell:MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            // connected to network
            if  network.checkNetwork()  //movies.count != 0
            {
                if let path = (movies[indexPath.row]["poster_path"] as? String)
                {
                    
                    cell.poster.sd_setImage(with: URL(string: imagePath+path),placeholderImage:UIImage.init(named: "loading.png"), completed:{
                        
                        image,error,chaceType,imageUrl in
                        
                        // add movies localy to core data
                        // add only 60 film for show on not connected mode
                        if self.movies.count<=60
                        {
                            
                            self.coredata.setId(id: self.movies[indexPath.row]["id"] as! Double)
                            self.coredata.addToMovies(name: self.movies[indexPath.row]["original_title"] as! String, overview: self.movies[indexPath.row]["overview"] as! String,
                                                      image: self.movies[indexPath.row]["poster_path"] as! String,
                                                      rate: self.movies[indexPath.row]["vote_average"] as! Double,
                                                      release: self.movies[indexPath.row]["release_date"] as! String, flag: 0)
                        }
                    })
                    
                }
            }
                // not connected
            else
            {
                if let path = (localMovies[indexPath.row].value(forKey: "image") as? String)
                {
                    
                    cell.poster.sd_setImage(with: URL(string: imagePath+path), completed: nil)
                    
                }
            }
            return cell
        }
        else
        {   // menu collection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            if indexPath.row == 0 // highest rated
            {
                cell.addSubview(setupMenuLabel(name: "Highest-Rated",x: 60, y: cell.frame.height/2, width: collectionView.frame.width, hight: collectionView.frame.height/8))
                cell.addSubview(setupMenuImage(name: "star",x: 5, y: cell.frame.height/2, width: 40, height: collectionView.frame.height/8))
            }
            else if indexPath.row == 1  // most popular
            {
                
                cell.addSubview(setupMenuLabel(name: "Most-Popular",x: 60, y: cell.frame.height/2, width: collectionView.frame.width, hight: collectionView.frame.height/8))
                cell.addSubview(setupMenuImage(name: "popular",x: 5, y: cell.frame.height/2, width: 40, height: collectionView.frame.height/8))
            }
            
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 0.4
            return cell
        }
        
    }
    
    
}

extension Home:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // films collection
        if collectionView.tag == 0
        {
            
            index = indexPath.row
            performSegue(withIdentifier: "detail", sender:self)
        }
        else  // menu collection
        {
            if indexPath.row == 0  // highest- rated
            {
                
                if network.checkNetwork()
                {
                    getApiData(url: "http://api.themoviedb.org/3/discover/movie?sort_by=vote_count.desc&api_key=d52a9c41632a8b38d8c0dd5b5652b937",appendFalg: 0)
                    
                }
                else
                {
                    let sortrate = localMovies.sorted { Float(truncating: $0.value(forKey: "frate") as! NSNumber) > Float(truncating: $1.value(forKey: "frate") as! NSNumber)}
                    popMovies = localMovies
                    localMovies = sortrate
                    collection.reloadData()
                    
                }
                homeTitle.title = "Highest-Rated Movies"
            }
            else if indexPath.row == 1  // most popularity
            {
                if network.checkNetwork()
                {
                    getApiData(url: "http://api.themoviedb.org/3/discover/movie?api_key=d52a9c41632a8b38d8c0dd5b5652b937",appendFalg: 0)
                    
                }
                else
                {
                    if popMovies.count != 0
                    {
                        localMovies = popMovies
                        collection.reloadData()
                    }
                    
                }
                homeTitle.title = "Popular Movies"
            }
            handledismiss()
        }
        
    }
    
    // chack that i scroll fro last cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // connected to network
        if network.checkNetwork()
        {
            if movies.count != 0 {
                if indexPath.row == movies.count - 1
                {
                    
                    let pageNo:Int = movies.count/20
                    
                    getApiData(url:"http://api.themoviedb.org/3/discover/movie?api_key=d52a9c41632a8b38d8c0dd5b5652b937&page=\(pageNo+1)",appendFalg: 1)
                }
            }
        }
    }
}


extension Home:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0
        {
            return CGSize(width: collectionView.bounds.size.width/2, height: CGFloat(collectionView.bounds.size.height/2))
        }
        else
            
        {
            
            return CGSize(width: collectionView.frame.width, height: 40)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
