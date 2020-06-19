//
//  DetailsCollections.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/19/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//
import UIKit
extension MovieDetailsController {
    func setupCollections(){
        youtubeCollection.delegate = self
        youtubeCollection.dataSource = self
        reviewsCollection.delegate = self
        reviewsCollection.dataSource = self
    }
}
extension MovieDetailsController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Networking.checkNetwork()
        {
            if collectionView.tag == 1
            {
                if reviewsArr.count==0
                {return 1}
                return reviewsArr.count
            }
            else
            {
                if trailers.count==0
                {return 1}
                return trailers.count
            }
        }
        else
        {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1  // reviews
        {
            let cell:RevCell = collectionView.dequeueReusableCell(withReuseIdentifier: "revCell", for: indexPath) as! RevCell
            if Networking.checkNetwork()
            {
                if reviewsArr.count == 0
                {
                    cell.reviewText.text = "No Reviews Are Available For This Movie "
                    
                }
                else
                {
                    cell.ReviewerImage.image = UIImage.init(named: "user.png")
                    cell.reviewerName.text = reviewsArr[indexPath.row]["author"] as? String
                    cell.reviewText.text = reviewsArr[indexPath.row]["content"] as? String
                }
            }
            else
            {
                cell.reviewText.text = "No Reviews Are Available Please Connect To Network"
            }
            return cell
        }
            
        else   // trailers
        {
            let cell:YoutubeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "youtubecell", for: indexPath) as! YoutubeCell
            if Networking.checkNetwork()
            {
                if trailers.count == 0
                {
                    cell.trailerName.text = "No Trailers Are Availble For This Movie "
                    
                }
                else
                {
                    if let name:String =  trailers[indexPath.row]["name"] as? String
                    {
                        cell.trailerName.text = name
                        cell.trailerImage.setImage(UIImage.init(named: "youtube"), for: .normal)
                        cell.layer.borderColor = UIColor.gray.cgColor
                        cell.layer.borderWidth = 0.4
                    }
                }
                
            }
            else
            {
                cell.trailerName.text = "No Trailers Are Availble Please Connect To Network "
                cell.trailerImage.setImage(UIImage.init(named: "no-connection"), for: .normal)
                
            }
            return cell
        }
    }
}

extension MovieDetailsController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0
        {
            if Networking.checkNetwork()
            {
                openTrailerOnYoutube(key: (trailers[indexPath.row]["key"]  as! String))
            }
        }
    }
    
    
    
}
extension MovieDetailsController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1
        {
            return CGSize(width: collectionView.bounds.size.width, height: CGFloat(collectionView.bounds.size.height))
        }
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(collectionView.bounds.size.height/2))
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
