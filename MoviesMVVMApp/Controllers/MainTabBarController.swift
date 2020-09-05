//
//  MainTabBarController.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/5/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    
    private func setupControllers() {
        let vc = ViewController()
        let navVC = UINavigationController(rootViewController: vc)
        
        navVC.tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)

        
        let favoritesVC = UIViewController()
        let favoritesNavVC = UINavigationController(rootViewController: favoritesVC)
        
        favoritesNavVC.tabBarItem.image = UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal)
        favoritesNavVC.tabBarItem.selectedImage = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal)
        
//        tabBar.tintColor = .clear
        viewControllers = [navVC, favoritesNavVC]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
