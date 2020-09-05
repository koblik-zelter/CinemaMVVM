//
//  MapViewModel.swift
//  MoviesMVVMApp
//
//  Created by Alex Koblik-Zelter on 9/3/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import MapKit

class MapViewModel: NSObject {
    
    private var locationManager: CLLocationManager
    
    var authorized: (() -> Void)?
    var showMapItems: (([MKMapItem]) -> Void)?
    var authorizationStatus: CLAuthorizationStatus?
    
    var mapItems: [MKMapItem]? {
        didSet {
            guard let mapItems = mapItems, let showItems = showMapItems else { return }
            showItems(mapItems)
        }
    }
    var centerCoordinate: CLLocationCoordinate2D? {
        locationManager.location?.coordinate
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        
        super.init()
    }
    
    private func getStatus() {
        let status = CLLocationManager.authorizationStatus()
        handleStatus(status)
    }
    
    private func handleStatus(_ status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            guard let authorized = authorized else { return }
            authorized()
        case .notDetermined:
            requestAuthorization()
        default:
            break
        }
    }
    
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCinema(region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Cinema"
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] (response, err) in
            guard let self = self else { return }
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            
            let mapItems = response.mapItems
            
            self.mapItems = mapItems
        }
    }
    
    func getDirection() {
        
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleStatus(status)
    }
}
