//
//  ImageView + MA.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/1/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(path: String) {
        if let image = ImageCache.shared.getImage(forKey: path) {
            print("from cache")
            self.image = image
            return
        }
        
        let urlString = "https://image.tmdb.org/t/p/w500/" + path
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self ] (data, response, error) in
            guard let self = self else { return }
            print("from url")
            if let error = error {
                print(error)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            ImageCache.shared.saveImage(image: image, forKey: path)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
