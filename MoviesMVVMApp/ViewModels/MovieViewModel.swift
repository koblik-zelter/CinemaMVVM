//
//  MovieViewModel.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/1/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

class MovieViewModel {
    private var movie: Movie
    
    var addedToFavorites: (() -> Void)?
    var onRemoveFromFavorites: (() -> Void)?
    var onError: ((CoreDataErrors) -> Void)?
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var ratingPercent: String {
        String(format: "%.1f", (movie.rating ?? 0) / 2)
    }
    
    var rating: Double {
        (movie.rating ?? 0) / 2
    }
    
    var desctiption: String {
        movie.overview
    }
    
    var imagePath: String? {
        movie.path
    }
    
    var title: String {
        movie.title
    }
    
    var year: String {
        String(movie.date.prefix(4))
    }
    
    var isFavorite: Bool {
        CoreDataManager.shared.isMovieInFavorites(movie: movie)
    }
    
    func saveMovieToFavorites() {
        if let err = CoreDataManager.shared.saveToFavorites(movie: movie) {
            guard let error = onError else { return }
            error(err)
            return
        }
    
        guard let onAdded = addedToFavorites else { return }
        onAdded()
    }
    
    func removeFromFavorites() {
        if let err = CoreDataManager.shared.removeMovie(movie: movie) {
            guard let error = onError else { return }
            error(err)
            return
        }
        
        guard let onRemoved = onRemoveFromFavorites else { return }
        onRemoved()
    }
}
