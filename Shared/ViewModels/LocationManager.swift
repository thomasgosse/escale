//
//  LocationManager.swift
//  Escale
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI
import MapKit


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManger = CLLocationManager()
    @Published var status: CLAuthorizationStatus?
    @Published var statusAsString: String = ""
                
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
        
        switch status {
        case .denied:
            statusAsString = "Jamais"
        case .authorizedWhenInUse:
            statusAsString = "Lorsque l'app est active"
        case .authorizedAlways:
            statusAsString = "Toujours"
        default:
            statusAsString = "Non determiné"
        }
    }
}
