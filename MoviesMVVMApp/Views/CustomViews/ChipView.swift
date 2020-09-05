//
//  ChipView.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/1/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class ChipView: UIView {
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "heart")
        return iv
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100%"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
//        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRating(_ rating: String) {
        self.ratingLabel.text = rating
    }
    
    private func configure() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 17
        self.backgroundColor = .init(white: 0.3, alpha: 0.7)
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [imageView, ratingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        
        self.addSubview(stackView)
        
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        ratingLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4)
        ])
    }
}
