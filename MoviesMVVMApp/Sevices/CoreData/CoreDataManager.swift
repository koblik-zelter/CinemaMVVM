//
//  CoreDataManager.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/5/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private var favoritesMovies: [FavoriteMovie] = []
    
    private init() { }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieObject")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchFavorites() -> [Movie] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        
        do {
            let favoritesMovies = try context.fetch(fetchRequest)
            self.favoritesMovies = favoritesMovies
            let movies = favoritesMovies.map { Movie(path: $0.path, title: $0.title ?? "", rating: $0.rating, overview: $0.overview ?? "", date: $0.date ?? "", duration: Int($0.duration)) }
            return movies
            
        } catch let fetchErr {
            print("Failed to fetch movied: \(fetchErr)")
            return []
        }
    }
    
    func saveToFavorites(movie: Movie) -> CoreDataErrors? {
        let context = persistentContainer.viewContext
        
        let favoriteMovie = FavoriteMovie(context: context)
        favoriteMovie.date = movie.date
        favoriteMovie.duration = Int32(movie.duration ?? 0)
        favoriteMovie.overview = movie.overview
        favoriteMovie.title = movie.title
        favoriteMovie.rating = movie.rating ?? 0
        favoriteMovie.path = movie.path
        
        do {
            try context.save()
            return nil
        } catch {
            return .cannotAdd
        }
    }
    
    func removeMovie(movie: Movie) -> CoreDataErrors? {
        let indexToDelete = favoritesMovies.firstIndex { $0.title == movie.title }
        guard let index = indexToDelete else { return .cannotDelete }
        let movieTodelete = favoritesMovies[index]
        let context = persistentContainer.viewContext
        context.delete(movieTodelete)
        
        do {
            try context.save()
            favoritesMovies.remove(at: index)
            return nil
        } catch {
            return .cannotDelete
        }
    }
    
    func isMovieInFavorites(movie: Movie) -> Bool {
        let movies = fetchFavorites()
        return movies.contains { $0.title == movie.title }
    }
}
