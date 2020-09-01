//
//  ImageCache.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/1/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private init() { }
    
    func saveImage(image: UIImage, forKey key: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self, let data = image.jpegData(compressionQuality: 0.8) else { return }
            if let filePath = self.filePath(forKey: key) {
                do  {
                    try data.write(to: filePath, options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
    func getImage(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key)
    }
}
