//
//  CoreData.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/5/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//
import UIKit
import CoreData

class LocalStorage {
    
    private var movies: [NSManagedObject] = []
    private var appDelegate: AppDelegate
    private var managedContext: NSManagedObjectContext
    private var fetchRequest: NSFetchRequest<NSManagedObject>
    static let shared = LocalStorage()
    var moviesCount: Int {
        getMovies().count
    }
    
    private init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    }
    
    func add(movie value: MovieViewModel, isFavorite: Bool = false)  {
        fetchRequest.predicate = NSPredicate.init(format:"id == \(value.id)")
        if let result = try? managedContext.fetch(fetchRequest) {
            if result.count == 0 {
                let entity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)
                let movie = NSManagedObject(entity: entity!, insertInto: managedContext)
                movie.setValue(value.id, forKey: "id")
                movie.setValue(value.originalTitle, forKey: "name")
                movie.setValue(value.moviePoster, forKey: "poster")
                movie.setValue(value.voteAverage, forKey: "rate")
                movie.setValue(value.releaseDate, forKey: "mRelease")
                movie.setValue(value.overview, forKey: "overview")
                movie.setValue(isFavorite, forKey: "isFavorite")
                do{
                     try managedContext.save()
                    print("Movie saved successfully")
                }
                catch let error as NSError{
                    print("error saving in core data : \(error)")
                }
            }
        }
    }
    
    func getMovies() -> [NSManagedObject] {
        do {
            movies =  try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print(error)
        }
        return movies
    }
    
    func getFavouriteMovies()-> [NSManagedObject]
    {
        fetchRequest.predicate =  NSPredicate.init(format: "flag == \(1)")
        do{
            movies =  try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print(error)
        }
        return movies
    }
    
    
    func addToFavourite(movie: Movie)
    {
        fetchRequest.predicate =  NSPredicate.init(format:"id == \(movie.id)")
        if let result = try? managedContext.fetch(fetchRequest){
            if result.count == 0
            {
               // add(mov: movie, isFavorite: true)
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
    
    func deleteFromFavourite(id: Int)
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
    
    
    func checkIsFavourite(id: Int) -> Int
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
