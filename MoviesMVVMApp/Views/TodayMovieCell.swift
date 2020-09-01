//
//  TodayMovieCell.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/1/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joker Joker Joker Joker Joker Joker Joker Joker"
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
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
        chipView.setRating(viewModel.rating)
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
                                     movieImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
                                     movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45)
        ])
        
        self.contentView.addSubview(chipView)
        NSLayoutConstraint.activate([chipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                                     chipView.heightAnchor.constraint(equalToConstant: 34),
                                     chipView.widthAnchor.constraint(equalToConstant: 85)
        ])
    }
    
    private func configureDetails() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
    
        contentView.addSubview(stackView)
    
        descriptionLabel.bottomAnchor.constraint(equalTo: chipView.topAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                                     stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                                     chipView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
    }
    
    
}
