//
//  CoreDataErrors.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/5/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

enum CoreDataErrors: String, Error {
    case cannotAdd = "Cannot add to favorites"
    case cannotDelete = "Cannot delete movie"
}
