//
//  NetworkError.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 8/30/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
