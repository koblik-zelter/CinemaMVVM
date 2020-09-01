//
//  UpcomingCell.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/1/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class TopRatedCell: UICollectionViewCell {
    private lazy var movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private lazy var chipView: ChipView = {
        let iv = ChipView()
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: MovieViewModel) {
        self.chipView.setRating(viewModel.rating)
        
        if let path = viewModel.imagePath {
            movieImageView.setImage(path: path)
        } else {
            movieImageView.image = #imageLiteral(resourceName: "joker")
        }
    }
    
    private func setupViews() {
        configureImageView()
        configureChipView()
    }
    
    private func configureImageView() {
        self.contentView.addSubview(movieImageView)
        NSLayoutConstraint.activate([movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureChipView() {
        self.contentView.addSubview(chipView)
        NSLayoutConstraint.activate([chipView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                                     chipView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                                     chipView.heightAnchor.constraint(equalToConstant: 34),
                                     chipView.widthAnchor.constraint(equalToConstant: 85)
        ])
    }
}
