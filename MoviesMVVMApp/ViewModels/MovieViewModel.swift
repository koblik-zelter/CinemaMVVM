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
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var rating: String {
        "\(Int((movie.rating ?? 0) * 10))%"
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
}
