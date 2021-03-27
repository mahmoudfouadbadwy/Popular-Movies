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
    
    //MARK:- Properties
    private var movies: [NSManagedObject] = []
    private var appDelegate: AppDelegate
    private var managedContext: NSManagedObjectContext
    private var fetchRequest: NSFetchRequest<NSManagedObject>
    private var entity: NSEntityDescription?
    static let shared = LocalStorage()
    var moviesCount: Int {
        getMovies().count
    }
    
    //MARK:- Initializer
    private init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        entity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)
    }
    
    //MARK:- Intents
    func add(movie value: MoviesData.ViewModel)  {
        fetchRequest.predicate = NSPredicate.init(format:"id == \(value.id)")
        if let result = try? managedContext.fetch(fetchRequest) {
            if  result.count == 0 {
                insertMovie(id: value.id,
                            name: value.originalTitle,
                            poster: value.moviePoster,
                            rate: value.voteAverage,
                            release: value.releaseDate,
                            overview: value.overview,
                            isFavorite: false)
            }
        }
    }
    
    private func insertMovie(id: Int, name: String, poster: String, rate: Double, release: String, overview: String, isFavorite: Bool) {
        guard let entity = entity else {
            return
        }
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        movie.setValue(id, forKey: "id")
        movie.setValue(name, forKey: "name")
        movie.setValue(poster, forKey: "poster")
        movie.setValue(rate, forKey: "rate")
        movie.setValue(release, forKey: "mRelease")
        movie.setValue(overview, forKey: "overview")
        movie.setValue(isFavorite, forKey: "isFavorite")
        do {
            try managedContext.save()
            print("Movie saved successfully")
        }
        catch let error as NSError{
            print("error saving in core data : \(error)")
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
    
    func getFavouriteMovies()-> [NSManagedObject]  {
        fetchRequest.predicate =  NSPredicate.init(format: "isFavorite == \(true)")
        do{
            movies =  try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print(error)
        }
        return movies
    }
    
    
    func addToFavourite(movie value: MovieDetailsData.Response) {
        fetchRequest.predicate =  NSPredicate.init(format:"id == \(value.id)")
        if let result = try? managedContext.fetch(fetchRequest) {
            if result.count == 0
            {
                insertMovie(id: value.id,
                            name: value.originalTitle,
                            poster: value.posterPath,
                            rate: value.voteAverage,
                            release: value.releaseDate,
                            overview: value.overview,
                            isFavorite: true)
            }
            else {
                result[0].setValue(true, forKey: "isFavorite")
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
            result[0].setValue(false, forKey: "isFavorite")
        }
        do{
            try managedContext.save()
        }
        catch let error as NSError{
            print("error deleting from core data : \(error)")
        }
        
    }
    
    
    func checkIsFavourite(id: Int) -> Bool
    {
        let idPredicate = NSPredicate.init(format:"id == \(id)")
        let isFavoritePredicate = NSPredicate.init(format:"isFavorite == \(true)")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ idPredicate,isFavoritePredicate])
        fetchRequest.predicate = andPredicate
        if let result = try? managedContext.fetch(fetchRequest) {
            return result.count != 0
        }
        return false
    }
    
}
