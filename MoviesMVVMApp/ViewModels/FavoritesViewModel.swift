//
//  FavoritesViewModel.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/5/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

class FavoritesViewModel {
    private(set) var movies: [Movie] = [] {
        didSet {
            guard let callBack = requestCallback else { return }
            callBack()
        }
    }
    
    var requestCallback: (() -> Void)?
    var onRemoveFromFavorites: (() -> Void)?
    var onError: ((CoreDataErrors) -> Void)?
    
    func fetchFavorites() {
        movies.removeAll()
        self.movies = CoreDataManager.shared.fetchFavorites()
    }
    
    func removeMovieAt(indexPath: IndexPath) {
        if let error = CoreDataManager.shared.removeMovie(movie: movies[indexPath.item]) {
            guard let errorCallback = onError else { return }
            errorCallback(error)
        }
        
        movies.remove(at: indexPath.item)
        guard let deleted = onRemoveFromFavorites else { return }
        deleted()
    }
    
    func getMovie(indexPath: IndexPath) -> Movie {
        return movies[indexPath.item]
    }
}
