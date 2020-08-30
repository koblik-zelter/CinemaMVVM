//
//  Movie.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 8/29/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

struct MovieResult: Codable {
    var page: Int
    var movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
    }
}

struct Movie: Codable {
    var path: String?
    var title: String
    var rating: Double?
    var overview: String
    var date: String
    
    private enum CodingKeys: String, CodingKey {
        case path = "poster_path"
        case title = "title"
        case rating = "vote_average"
        case overview = "overview"
        case date = "release_date"
    }
    
    enum Actions {
        case fetchMovies
        case updateData
    }
}
