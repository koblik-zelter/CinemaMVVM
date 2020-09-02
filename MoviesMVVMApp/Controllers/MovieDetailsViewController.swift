//
//  MovieDetailsViewController.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/2/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Private properties
    
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "joker")
        iv.contentMode = .scaleToFill
        iv.addBlurView()
        return iv
    }()
    
    private lazy var movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "joker")
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    private var viewModel: MovieViewModel
    
    // MARK: - Init
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        if let path = viewModel.imagePath {
            backgroundImageView.setImage(path: path)
            movieImageView.setImage(path: path)
        } else {
            movieImageView.image = #imageLiteral(resourceName: "joker")
            backgroundImageView.image = #imageLiteral(resourceName: "joker")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        print(viewModel.rating)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        self.view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                                     backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.view.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
                                     movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
                                     movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
                                     movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.4)
        ])
        
    }

}
