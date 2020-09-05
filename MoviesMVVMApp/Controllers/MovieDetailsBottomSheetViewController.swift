//
//  MovieDetailsBottomSheetViewController.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/3/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import Cosmos
import MapKit

class MovieDetailsBottomSheetViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.title
        label.numberOfLines = 2
        label.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
            weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var ratingView: CosmosView = {
        let ratingView = CosmosView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.rating = viewModel.rating
        ratingView.isUserInteractionEnabled = false
        ratingView.settings.fillMode = .precise
        ratingView.settings.filledColor = .lightGray
        ratingView.settings.filledBorderColor = .lightGray
        ratingView.settings.emptyBorderColor = .lightGray
        ratingView.text = viewModel.ratingPercent
        return ratingView
    }()
    
    private lazy var descriptionLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.desctiption
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        label.isEditable = false
        label.isSelectable = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize,
            weight: .regular)
        label.text = viewModel.year
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        return mapView
    }()
    
    private var viewModel: MovieViewModel
    private var mapViewModel: MapViewModel
    
    // MARK: - Init
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        self.mapViewModel = MapViewModel(locationManager: CLLocationManager())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupViews()
        bindMap()
        mapViewModel.requestAuthorization()
    }
    
    private func setupViews() {
        setupRatingView()
        setupTitleLabel()
        setupYearLabel()
        setupDescription()
        setupMapView()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                                     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     titleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 32)
        ])
    }
    
    private func setupRatingView() {
        view.addSubview(ratingView)
        NSLayoutConstraint.activate([ratingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                                     ratingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                                     ratingView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupYearLabel() {
        view.addSubview(yearLabel)
        NSLayoutConstraint.activate([yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                                     yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
    
    private func setupDescription() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([descriptionLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 16),
                                     descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                                     descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionLabel.contentSize.height * 1.4)
        ])
    }
    
    private func setupMapView() {
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMapController)))
        view.addSubview(mapView)
        NSLayoutConstraint.activate([mapView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                                     mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                                     mapView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
    }
    
    private func bindMap() {
        mapViewModel.authorized = { [weak self] in
            guard let self = self else { return }
            self.mapView.showsUserLocation = true
            if let coordinates = self.mapViewModel.centerCoordinate {
                let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 5000, longitudinalMeters: 5000)
                self.mapView.setRegion(region, animated: false)
            }
            self.mapViewModel.getCinema(region: self.mapView.region)
        }
        
        mapViewModel.showMapItems = { [weak self] items in
            guard let self = self else { return }
            self.showMapItems(mapItems: items)
        }
        
        
    }
    
    private func showMapItems(mapItems: [MKMapItem]) {
        var nearbyAnnotations: [MKAnnotation] = []
        if mapItems.count > 0 {
            for item in mapItems {
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.subtitle = item.phoneNumber
                if let location = item.placemark.location {
                    annotation.coordinate = location.coordinate
                }
                nearbyAnnotations.append(annotation)
            }
        }
        
        self.mapView.showAnnotations(nearbyAnnotations, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func openMapController() {
        let vc = MapViewController(mapViewModel: mapViewModel)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
