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
        collection.delegate = self
        collection.dataSource = self
    }
}

extension Home: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0  // movies collection
        {
            return movies.count
        }
        else
        {
            return 2   // menu collection
        }
}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // movies collection
        if collectionView.tag == 0
        {
            let cell:MovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let path = (movies[indexPath.row].moviePoster!)
            cell.poster.sd_setImage(with: URL(string: Constants.imagePath + path),placeholderImage:UIImage.init(named: "loading.png"))
            // add movies localy to core data
            // add only 60 movie for show on not connected mode
            if Networking.checkNetwork(){
                if self.movies.count<=60
                {
                    localHomeVM.addMovieTolocalStorage(id: self.movies[indexPath.row].id, name: self.movies[indexPath.row].originalTitle, overview: self.movies[indexPath.row].overview, image: self.movies[indexPath.row].moviePoster, rate: self.movies[indexPath.row].voteAverage, release: self.movies[indexPath.row].releaseDate)
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
        // movies collection
        if collectionView.tag == 0
        {
            index = indexPath.row
            performSegue(withIdentifier: "detail", sender:self)
        }
            // menu collection
        else
        {
            if indexPath.row == 0  // highest- rated
            {
                if Networking.checkNetwork()
                {
                    homeVM.getmovies(by: Constants.moviesTopRate, appendFlag: 0, completion: {[weak self] (results) in
                        self?.movies = results
                    })
                }
                else
                {
                    let sortrate = movies.sorted { Double(truncating: $0.voteAverage! as NSNumber) > Double(truncating: $1.voteAverage! as NSNumber)}
                    popMovies = movies
                    movies = sortrate
                    
                }
                homeTitle.title = "Highest-Rated Movies"
            }
            else if indexPath.row == 1  // most popularity
            {
                if Networking.checkNetwork()
                {
                    homeVM.getmovies(by: Constants.moviesUrl, appendFlag: 0, completion: {[weak self ] (results) in
                        self?.movies = results
                    })
                    
                }
                else
                {
                    if popMovies.count != 0
                    {
                        movies = popMovies
                    }
                    
                }
                homeTitle.title = "Popular Movies"
            }
            handledismiss()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // connected to network
        if Networking.checkNetwork()
        {
            if movies.count != 0 {
                if indexPath.row == movies.count - 1
                {
                    let pageNo:Int = movies.count/20
                    homeVM.getmovies(by: "\(Constants.moviesUrl)&page=\(pageNo+1)", appendFlag: 1, completion: { [weak self](results) in
                        self?.movies = results
                    })
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
