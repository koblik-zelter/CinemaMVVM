//
//  UIDevice + MA.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/3/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
}
