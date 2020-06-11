//
//  CoreData.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/5/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//
import UIKit
import CoreData
class CoreData{
    var movies:[NSManagedObject] = []
    var appDelegate:AppDelegate
    var managedContext:NSManagedObjectContext
    var fetchRequest:NSFetchRequest<NSManagedObject>
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    }

    func addToStorage(mov:Movie,flag:Int)
    {
        fetchRequest.predicate = NSPredicate.init(format:"id == \(mov.id)")
        if let result = try? managedContext.fetch(fetchRequest){
            if result.count == 0{
                let entity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)
                let movie = NSManagedObject(entity: entity!, insertInto: managedContext)
                movie.setValue(mov.id, forKey: "id")
                movie.setValue(mov.originalTitle, forKey: "name")
                movie.setValue(mov.posterPath, forKey: "image")
                movie.setValue(mov.voteAverage, forKey: "frate")
                movie.setValue(mov.releaseDate, forKey: "frelease")
                movie.setValue(mov.overview, forKey: "overview")
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
    
//     func getFavouriteMovies()-> [NSManagedObject]
//    {
//        fetchRequest.predicate =  NSPredicate.init(format:"flag == \(1)")
//        do{
//            movies =  try managedContext.fetch(fetchRequest)
//        }
//        catch let error as NSError{
//            print(error)
//        }
//        return movies
//    }
//
//    func addToFavourite(id:Double,name:String,overview:String,image:String,rate:Double,release:String)
//    {
//        fetchRequest.predicate =  NSPredicate.init(format:"id == \(id)")
//        if let result = try? managedContext.fetch(fetchRequest){
//            if result.count == 0
//            {
//                addToMovies(id:id,name: name, overview: overview, image: image, rate: rate, release: release, flag: 1)
//            }
//            else
//            {
//                result[0].setValue(1, forKey: "flag")
//                do{
//                    try managedContext.save()
//                }
//                catch let error as NSError{
//                    print("error saving in core data : \(error)")
//                }
//            }
//        }
//    }
//
//    func deleteFromFavourite(id:Double)
//    {
//        fetchRequest.predicate =  NSPredicate.init(format:"id == \(id)")
//        if let result = try? managedContext.fetch(fetchRequest){
//            result[0].setValue(0, forKey: "flag")
//        }
//        do{
//            try managedContext.save()
//        }
//        catch let error as NSError{
//            print("error saving in core data : \(error)")
//        }
//
//    }
//
//
//    func checkIsFavourite(id:Double)->Int
//    {
//        let idPredicate = NSPredicate.init(format:"id == \(id)")
//        let flagPredicate = NSPredicate.init(format:"flag == \(1)")
//        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ idPredicate,flagPredicate])
//        fetchRequest.predicate = andPredicate
//        if let result = try? managedContext.fetch(fetchRequest){
//            return result.count
//        }
//        return 0
//    }
//
}
