//
//  MapViewController.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/4/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    private var mapViewModel: MapViewModel
    
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        setupMapView()
        setupCloseButton()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([mapView.topAnchor.constraint(equalTo: view.topAnchor),
                                     mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let status = mapViewModel.authorizationStatus, status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        addMapItems()
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                                     closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func addMapItems() {
        guard let mapItems = mapViewModel.mapItems else { return }
        
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
    
    @objc private func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "markerId"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
                
        var markerAnnotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
        if markerAnnotationView == nil {
            markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            markerAnnotationView?.canShowCallout = true
        }
                
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        rightButton.setImage(UIImage(systemName: "location"), for: .normal)
        markerAnnotationView!.rightCalloutAccessoryView = rightButton
        
        return markerAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        mapViewModel
        let directionRequest = MKDirections.Request()
        
        // Set the source and destination of the route
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .any
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (routeResponse, routeError) -> Void in
            
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                
                return
            }
            
            let route = routeResponse.routes[0]
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
        }
    }
}
