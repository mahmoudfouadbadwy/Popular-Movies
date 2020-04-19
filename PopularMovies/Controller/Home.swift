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


class Home: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
   
    // variable
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
    let Menulabel = { (name:String ,x:CGFloat,y:CGFloat,width:CGFloat,hight:CGFloat) -> UILabel in
        let label = UILabel()
        label.text = name
        label.textColor = UIColor.white
        label.frame = CGRect(x:x,y:y,width:width,height:hight)
        return label
    }
    let MenuImage = {(name:String, x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat)-> UIImageView in
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.image = UIImage.init(named:name)
        image.frame = CGRect(x: x, y: y, width: width, height: height)
        return image
    }
  
    // collection methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if collectionView.tag==0  // films collection
      {
        if network.checkNetwork(){  // connected to network
          return movies.count
        }
        else{  // not connected
            return localMovies.count
        }
      }
      else
      {return 2}
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
                cell.addSubview(Menulabel("Highest-Rated",60, cell.frame.height/2, collectionView.frame.width, collectionView.frame.height/8))
                cell.addSubview(MenuImage("star",5, cell.frame.height/2, 40, collectionView.frame.height/8))
            }
            else if indexPath.row == 1  // most popular
            {
                
                cell.addSubview(Menulabel("Most-Popular",60, cell.frame.height/2, collectionView.frame.width, collectionView.frame.height/8))
                cell.addSubview(MenuImage("popular",5, cell.frame.height/2, 40, collectionView.frame.height/8))
            }
            
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 0.4
            return cell
        }
        
    }
    
    
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
    
    // item layout in collectionView
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

    // custom view -- collection
    let blackView = UIView()
    let collectionMenu :UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.black
        cv.tag = 1
        return cv
    }()
    
    // show navigation menu
    func showMenu()
    {
        if let window = UIApplication.shared.keyWindow
        {
            // view
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action:#selector(handledismiss)))
            blackView.backgroundColor = UIColor(white: 0, alpha:0.5)
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            // collection
            window.addSubview(collectionMenu)
            collectionMenu.frame = CGRect(x: 0, y: 0 ,width: window.frame.width, height:0)
            collectionMenu.alpha = 1
            
           //  animation
            UIView.animate(withDuration:0.5) {
                self.blackView.alpha = 1
                self.collectionMenu.frame = CGRect(x: 0, y: 0 , width: window.frame.width, height: 110)
            }
        }
    }
    
    // dismis navigation menu
    @objc func handledismiss()
    {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.collectionMenu.frame = CGRect(x:0,y:0,width: self.collectionMenu.frame.width, height:0)
              }
    }

    // call backmethods
    override func viewDidLoad() {
        super.viewDidLoad()
        // film collection
        collection.delegate = self
        collection.dataSource = self
        // menu collection
        collectionMenu.delegate = self
        collectionMenu.dataSource = self
        collectionMenu.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        
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
        ReachabilityManager.shared.removeListener(listener: self as NetworkStatusListener)
    }

}
