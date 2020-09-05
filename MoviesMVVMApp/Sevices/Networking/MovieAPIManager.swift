//
//  MovieAPIManager.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 8/29/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import Alamofire

final class MovieAPIManager: ApiManager  {
    
    private let path = "https://api.themoviedb.org/3/"
    
    static var shared: MovieAPIManager = MovieAPIManager()
    
    func getTodayMovies(page: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        let parameters: Parameters = ["api_key": getApiKey()]
        AF.request("\(path)movie/now_playing", method: .get, parameters: parameters).response { [weak self] response in
            print(response.response)
            guard let self = self else { return }
            
            self.genericHandler(response: response, completion: completion)
        }
    }
    
    func getTopRatedMovies(page: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        let parameters: Parameters = ["api_key": getApiKey(), "page": page]
        AF.request("\(path)movie/top_rated", method: .get, parameters: parameters).response(queue: .global()) { [weak self] response in
            guard let self = self else { return }
            
            self.genericHandler(response: response, completion: completion)
        }
    }
    
    private func genericHandler(response: AFDataResponse<Data?>, completion: @escaping(Result<[Movie], NetworkError>) -> Void) {
        guard let httpResponse = response.response, httpResponse.statusCode == 200 else {
            completion(.failure(.invalidResponse))
            return
        }
        
        guard let data = response.data else {
            completion(.failure(.invalidData))
            return
        }
        
        do {
            let result = try JSONDecoder().decode(MovieResult.self, from: data)
            completion(.success(result.movies))
        }
        catch  {
            completion(.failure(.invalidData))
        }
    }
    
    private func getApiKey() -> String {
        return "d986890114170e67861f2911dd10257f"
    }
}



