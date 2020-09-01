//
//  MoviesViewModel.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 8/31/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

class MoviesViewModel {
    
    // MARK: - Private properties
    
    private var todayPage = 1
    private var upcomingPage = 1
    
    // MARK: - Public properties
    
    var sections: [Section] = []
    
    var requestCallback: (() -> Void)?
    // MARK: - Public methods
    
    func requestData() {
        let manager = MovieAPIManager.shared
        sections.removeAll()
        manager.getTopRatedMovies(page: todayPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.sections.append(Section(type: .topRated, movies: movies))
                manager.getTodayMovies(page: self.upcomingPage) { result in
                    switch result {
                    case .success(let movies):
                        self.sections.append(Section(type: .today, movies: movies))
                        guard let callback = self.requestCallback else { return }
                        DispatchQueue.main.async {
                            callback()
                        }
                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func getSectionTitleAt(_ index: Int) -> String? {
        if index >= 0 && index < sections.count {
            return sections[index].type.rawValue
        }
        
        return nil
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        if section >= 0 && section < sections.count {
            return sections[section].movies.count
        }
        return 0
    }
    
    func getMovie(indexPath: IndexPath) -> Movie {
        return sections[indexPath.section].movies[indexPath.item]
    }
}
