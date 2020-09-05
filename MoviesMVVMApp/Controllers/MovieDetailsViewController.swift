//
//  MovieDetailsViewController.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/2/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import FittedSheets

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
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBottomController()
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
        
        let likeButton = UIButton()
        likeButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2)), for: .normal)
        let shareButton = UIButton()
        shareButton.addTarget(self, action: #selector(shareMovie), for: .touchUpInside)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2)), for: .normal)
        let stackView = UIStackView(arrangedSubviews: [likeButton, UIView(), shareButton])
        stackView.axis = .horizontal
        stackView.spacing = 4
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    private func setupViews() {
        self.view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                                     backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.view.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                                     movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
                                     movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
                                     movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.4)
        ])
    }
    
    private func setupBottomController() {
        
        let offset: CGFloat = UIDevice.current.hasNotch ? 16 : 0
        
        let vc = MovieDetailsBottomSheetViewController(viewModel: viewModel)
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(view.frame.height - offset - 96 - (view.frame.width - 96) * 1.4), .percent(0.85)], options: SheetOptions(useInlineMode: true))
        sheetController.dismissOnPull = false
        sheetController.dismissOnOverlayTap = false
        sheetController.view.translatesAutoresizingMaskIntoConstraints = false
        
        sheetController.willMove(toParent: self)
        self.addChild(sheetController)
        self.view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            sheetController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            sheetController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        sheetController.animateIn()
    }
    
    // MARK: - Actions
    
    @objc private func shareMovie() {
        print("Share")
    }
    
    @objc private func addToFavorites() {
        print("Added to Favorites")
    }

}
