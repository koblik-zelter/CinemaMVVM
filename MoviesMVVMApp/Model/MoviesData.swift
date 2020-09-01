//
//  ViewController + DiffableDataSource.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 8/31/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

struct Section: Hashable {
    var type: SectionType
    var movies: [Movie]
}

enum SectionType: String, Hashable {
    case topRated = "Top Rated"
    case today = "Today"
}
