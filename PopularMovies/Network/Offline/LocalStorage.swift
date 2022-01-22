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
    
    //MARK: - Properties
    private var movies: [Movie] = []
    private var appDelegate: AppDelegate
    private var managedContext: NSManagedObjectContext
    private var fetchRequest: NSFetchRequest<Movie>
    private var entity: NSEntityDescription?
    static let shared = LocalStorage()
    var moviesCount: Int {
        getMovies().count
    }
    
    //MARK: - Initializer
    private init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchRequest = Movie.fetchRequest()
        entity = Movie.entity()
    }
    
    //MARK: - Intents
    func add(movie value: MoviesData.ViewModel)  {
        fetchRequest.predicate = NSPredicate.init(format:"id == \(value.id)")
        if let result = try? managedContext.fetch(fetchRequest), result.isEmpty {
            insertMovie(id: value.id,
                        name: value.originalTitle,
                        poster: value.moviePoster,
                        rate: value.voteAverage,
                        release: value.releaseDate,
                        overview: value.overview,
                        isFavorite: false)
        }
    }
    
    private func insertMovie(id: Int, name: String, poster: String, rate: Double, release: String, overview: String, isFavorite: Bool) {
        guard let entity = entity else {
            return
        }
        let movie = Movie(entity: entity, insertInto: managedContext)
        movie.id = Int64(id)
        movie.name = name
        movie.poster = poster
        movie.rate = rate
        movie.mRelease = release
        movie.overview = overview
        movie.isFavorite = isFavorite
        appDelegate.saveContext()
    }
    
    func getMovies() -> [Movie] {
        do {
            movies =  try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError {
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
    
    
    func addToFavourite(movie value: MovieDetailsData.ViewModel) {
        fetchRequest.predicate =  NSPredicate.init(format:"id == \(value.id)")
        if let result = try? managedContext.fetch(fetchRequest) {
            if result.count == 0 {
                insertMovie(id: value.id,
                            name: value.originalTitle,
                            poster: value.moviePoster,
                            rate: value.voteAverage,
                            release: value.releaseDate,
                            overview: value.overview,
                            isFavorite: true)
            }
            else {
                result[0].isFavorite = true
                appDelegate.saveContext()
            }
        }
    }
    
    func deleteFromFavourite(id: Int) {
        fetchRequest.predicate =  NSPredicate.init(format:"id == \(id)")
        if let result = try? managedContext.fetch(fetchRequest) {
            result[0].isFavorite = false
            appDelegate.saveContext()
        }
    }
    
    
    func checkIsFavourite(id: Int) -> Bool {
        var isFavorite = false
        let idPredicate = NSPredicate.init(format: "id == \(id)")
        let isFavoritePredicate = NSPredicate.init(format: "isFavorite == \(true)")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ idPredicate,isFavoritePredicate])
        fetchRequest.predicate = andPredicate
        if let result = try? managedContext.fetch(fetchRequest) {
            isFavorite = !result.isEmpty
        }
        return isFavorite
    }
    
    func getMovieBy(id: Int) -> Movie? {
        fetchRequest.predicate = NSPredicate.init(format: "id == \(id)")
        let result = try? managedContext.fetch(fetchRequest)
        return result?[0]
    }
}
