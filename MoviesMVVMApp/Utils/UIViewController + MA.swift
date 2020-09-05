//
//  UIViewController + MA.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/5/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import SPAlert

fileprivate var alertView: SPAlertView!

extension UIViewController {
    func showAlert(title: String, presset: SPAlertPreset) {
        if let alert = alertView {
            alert.dismiss()
        }
        alertView = SPAlertView(title: title, message: nil, preset: presset)
        alertView.duration = 3
        alertView.dismissByTap = true
        alertView.present()
    }
}
