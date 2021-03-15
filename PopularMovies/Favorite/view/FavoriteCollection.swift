//
//  FavoriteCollection.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/23/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit

extension FavoriteViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "favDetails", sender:self)
    }
}

extension FavoriteViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FavouriteCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "favouriteCell", for: indexPath) as! FavouriteCell)
        if movies.count != 0
        {
            if let path = (movies[indexPath.row].moviePoster)
            {

                cell.favouriteImage.sd_setImage(with: URL(string: Constants.imagePath+path), completed: nil)
            }
        }
        return cell
    }
}
extension FavoriteViewController: UICollectionViewDelegateFlowLayout{
    
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
}



