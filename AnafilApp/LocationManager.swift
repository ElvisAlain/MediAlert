//
//  LocationManager.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 13/11/25.
//

import SwiftUI
import Foundation
import MapKit
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    // Región Inicial, se actualizará sola
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.0414, longitude: -98.2063), // Puebla Centro (default)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var hospitals: [MKMapItem] = []
    var userLocation: CLLocation? // Ubicación exacta
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
        withAnimation {
            region = MKCoordinateRegion (
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
        searchNearbyHospitals()
    }
    
    func searchNearbyHospitals() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hospital"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start {response, error in
            guard let response = response else {return}
            
            // Ordenar por distancia, del más cercano al más lejano
            if let myLoc = self.userLocation {
                self.hospitals = response.mapItems.sorted{item1, item2 in
                    let loc1 = item1.placemark.location ?? CLLocation()
                    let loc2 = item2.placemark.location ?? CLLocation()
                    return myLoc.distance(from: loc1) < myLoc.distance(from: loc2)
                }
            } else {
                self.hospitals = response.mapItems
            }
        }
    }
}
