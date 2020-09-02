//
//  TodayMovieCell.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/1/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import Cosmos

class TodayMovieCell: UICollectionViewCell {
    
    private lazy var movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleToFill
        iv.image = #imageLiteral(resourceName: "joker")
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joker"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        //        label.textAlignment = .center
        return label
    }()
    
    private lazy var chipView: ChipView = {
        let iv = ChipView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var ratingView: CosmosView = {
        let ratingView = CosmosView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.rating = 4.5
        ratingView.isUserInteractionEnabled = false
        ratingView.settings.fillMode = .precise
        ratingView.settings.filledColor = .lightGray
        ratingView.settings.filledBorderColor = .lightGray
        ratingView.settings.emptyBorderColor = .lightGray
        ratingView.text = "90%"
        return ratingView
    }()
    
    private lazy var descriptionLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joker Joker Joker Joker Joker Joker Joker Joker"
        label.textAlignment = .left
        label.textContainer.lineBreakMode = .byTruncatingTail
        label.textContainer.maximumNumberOfLines = 8
        label.isUserInteractionEnabled = false
        label.isEditable = false
        label.isSelectable = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.desctiption
        ratingView.rating = viewModel.rating
        ratingView.text = viewModel.ratingPercent
        if let path = viewModel.imagePath {
            movieImageView.setImage(path: path)
        } else {
            movieImageView.image = #imageLiteral(resourceName: "joker")
        }
    }
    
    private func setupViews() {
        configureImageView()
        configureDetails()
    }
    
    private func configureImageView() {
        contentView.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                     movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     movieImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),
                                     movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45)
        ])
    }
    
    private func configureDetails() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .top
        stackView.distribution = .fill
    
        contentView.addSubview(stackView)
        
        ratingView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                                     stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        descriptionLabel.sizeToFit()
        
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([descriptionLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                                     descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
                                     descriptionLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor)
        ])
        

    }
    
    
}
