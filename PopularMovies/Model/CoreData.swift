//
//  CoreData.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/5/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class CoreData: NSObject {
    
    private var id:Double = 0
    private var name:String=""
    private var overview:String=""
    private var image:String=""
    private var rate:Double=0.0
    private var release:String=""
    private var flag:Int = 0
    private var movies:[NSManagedObject] = []
    private let appDelegate:AppDelegate
    private let managedContext:NSManagedObjectContext
    private let fetchRequest:NSFetchRequest<NSManagedObject>
    override init() {
       appDelegate = UIApplication.shared.delegate as! AppDelegate
       managedContext = appDelegate.persistentContainer.viewContext
       fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    }
    func setId(id:Double) {
            self.id = id
    }
    
    func getId()->Double
    {
        return self.id
    }
    
    func setName(name:String){
        self.name = name
    }
    func getName()->String
    {
        return name
    }
    func setOverview(overview:String){
        self.overview = overview
    }
    func getOverview()->String
    {
        return overview
    }
    func setImage(image:String){
        self.image = image
    }
    func getImage()->String
    {
        return image
    }
    func setRate(rate:Double) {
        self.rate = rate
    }
    
    func getRate()->Double
    {
        return self.rate
    }
    func setRelease(release:String)
    {
        self.release = release
    }
    func getRealease()->String{
        return self.release
    }
    
    func setFlag(flag:Int)
    {
        self.flag = flag
    }
    func getFlag()->Int
    {
        return flag
    }
    
    
    func addToMovies(name:String,overview:String,image:String,rate:Double,release:String,flag:Int)
    {
        fetchRequest.predicate = NSPredicate.init(format:"id == \(id)")
        if let result = try? managedContext.fetch(fetchRequest){
            if result.count == 0{
                let entity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)
                let movie = NSManagedObject(entity: entity!, insertInto: managedContext)
                movie.setValue(self.id, forKey: "id")
                movie.setValue(name, forKey: "name")
                movie.setValue(image, forKey: "image")
                movie.setValue(rate, forKey: "frate")
                movie.setValue(release, forKey: "frelease")
                movie.setValue(overview, forKey: "overview")
                movie.setValue(flag, forKey: "flag")
                do{
                    try managedContext.save()
                }
                catch let error as NSError{
                    print("error saving in core data : \(error)")
                }
            }
            
        }
       
    }
    
    
    
    func getFromMovies()-> [NSManagedObject]{
     
        do{
            
            movies =  try managedContext.fetch(fetchRequest)
        
            
        }
        catch let error as NSError{
            print(error)
        }
        return movies
        
    }
    
    func getFavouriteMovies()-> [NSManagedObject]
    {
        fetchRequest.predicate =  NSPredicate.init(format:"flag == \(1)")
        do{
            movies =  try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print(error)
        }
        return movies
    }
    
    
    
    func addToFavourite(name:String,overview:String,image:String,rate:Double,release:String,flag:Int)
    {
        fetchRequest.predicate =  NSPredicate.init(format:"id == \(id)")
        if let result = try? managedContext.fetch(fetchRequest){
            if result.count == 0
            {
                addToMovies(name: name, overview: overview, image: image, rate: rate, release: release, flag: flag)
            }
            else
            {
                 result[0].setValue(1, forKey: "flag")
                do{
                    try managedContext.save()
                }
                catch let error as NSError{
                    print("error saving in core data : \(error)")
                }
            }
        }
    }
    
    
    
    func deleteFromFavourite(id:Double)
    {
        fetchRequest.predicate =  NSPredicate.init(format:"id == \(id)")
        if let result = try? managedContext.fetch(fetchRequest){
            result[0].setValue(0, forKey: "flag")
        }
        do{
            try managedContext.save()
        }
        catch let error as NSError{
            print("error saving in core data : \(error)")
        }
    
    }
    
    
    func checkIsFavourite(id:Double)->Int
    {
        let idPredicate = NSPredicate.init(format:"id == \(id)")
        let flagPredicate = NSPredicate.init(format:"flag == \(1)")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ idPredicate,flagPredicate])
        fetchRequest.predicate = andPredicate
        if let result = try? managedContext.fetch(fetchRequest){
              return result.count
        }
        return 0
    }

}
