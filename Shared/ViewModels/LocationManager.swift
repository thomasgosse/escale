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
            statusAsString = NSLocalizedString("Never", comment: "Location access is denied")
        case .authorizedWhenInUse:
            statusAsString = NSLocalizedString("Location in use", comment: "Location access authorize while app is in use")
        case .authorizedAlways:
            statusAsString = NSLocalizedString("Always", comment: "Location access authorized always")
        default:
            statusAsString = NSLocalizedString("Not determined", comment: "Location access not determined")
        }
    }
}
