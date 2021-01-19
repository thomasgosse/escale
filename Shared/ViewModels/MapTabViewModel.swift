//
//  LocationManager.swift
//  travelapp
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI
import MapKit


class MapTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManger = CLLocationManager()
    @Published var firstDetectedCoordinate: CLLocationCoordinate2D?
    @Published var status: CLAuthorizationStatus?
    @Published var didDetectOnce: Bool = false
            
    @Published var searchLandmarks: [SearchLandmark] = []
    @Published var userLandmarks: [UserLandmark] = []
    
    override init() {
        super.init()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Auth detected:", manager.authorizationStatus.rawValue)
        status = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if didDetectOnce == false {
            firstDetectedCoordinate = location.coordinate
            didDetectOnce = true
        }
    }
}
