//
//  MovieDetail.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import AFNetworking
class MovieDetail: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var youtubeCollection: UICollectionView!
    @IBOutlet weak var reviewsCollection: UICollectionView!
    @IBOutlet weak var cosmosview: CosmosView!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var MovieDate: UILabel!
    @IBOutlet weak var MovieFav: UIButton!
    let network = NetworkModel()
    var imagePath:String = "http://image.tmdb.org/t/p/w185/"
    var reviewPath:String = "https://api.themoviedb.org/3/movie/"
    var reviewPath2:String = "/reviews?api_key=d52a9c41632a8b38d8c0dd5b5652b937"
    var filmName:String = ""
    var filmImage:String = ""
    var filmRelease:String = ""
    var filmOverView:String = ""
    var filmRate:Double = 0.0
    var filmId:Double = 0.0
    var trailers:[Dictionary<String,Any>] = []
    var reviewsArr:[Dictionary<String,Any>] = []
    var core:CoreData?
    let api:API = API()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if network.checkNetwork()
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
            if network.checkNetwork()
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
          if network.checkNetwork()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0
        {
            if network.checkNetwork()
            {
              openTrailerOnYoutube(key: (trailers[indexPath.row]["key"]  as! String))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeCollection.delegate = self
        youtubeCollection.dataSource = self
        reviewsCollection.delegate = self
        reviewsCollection.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // favourite
       
          core = CoreData()
          core?.setId(id: filmId)
       
         if core?.checkIsFavourite(id: filmId) != 0
           {
            MovieFav.tintColor = UIColor.red
           }
        if network.checkNetwork()
        {
            // reviews
            showReviews()
            // trailers
            shwoTrailers()
            
        }
      
        
        if filmName != ""
        {
          movieName.text = filmName
        }
        if filmImage != ""
        {
         movieImage!.sd_setImage(with:URL(string:imagePath+filmImage),completed: nil)
        }
        if filmRelease != ""
        {
          MovieDate.text = filmRelease
        }
        else
        {
            MovieDate.font =  MovieDate.font.withSize(12)
        }
        if filmOverView != ""
        {
         movieOverview.text = filmOverView
        }
        cosmosview.settings.fillMode = StarFillMode.precise
        cosmosview.rating = filmRate/2
        cosmosview.isUserInteractionEnabled = false
    }


    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func makeFavourite(_ sender: UIButton) {
            // make favourite
           if (MovieFav.tintColor == UIColor.white)
           {
             MovieFav.tintColor = UIColor.red
             core?.addToFavourite(name: filmName, overview: filmOverView, image: filmImage, rate: filmRate, release: filmRelease,flag: 1)
           }
           else{  // delete from favourite
               MovieFav.tintColor = UIColor.white
               core?.deleteFromFavourite(id: filmId)
           }
        
        
        
    }
    

    func shwoTrailers()
    {
        
             api.getdata(url: "https://api.themoviedb.org/3/movie/"+String(filmId)+"/videos?api_key=d52a9c41632a8b38d8c0dd5b5652b937&language=en-US",appendFlag: 0) { (result) in
            self.trailers = result
            self.youtubeCollection.reloadData()
        
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
        api.getdata(url: reviewPath+String(filmId)+reviewPath2,appendFlag: 0) { (result) in
            self.reviewsArr = result
            self.reviewsCollection.reloadData()
        }
    }
}
