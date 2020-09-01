//
//  APIManager.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 8/29/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

protocol ApiManager {
    func getTodayMovies(page: Int, completion: @escaping(Result<[Movie], NetworkError>) -> Void)
    func getTopRatedMovies(page: Int, completion: @escaping(Result<[Movie], NetworkError>) -> Void)
    
    static var shared: Self { get }
}
