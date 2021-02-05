//
//  Landmark.swift
//  Escale (iOS)
//
//  Created by Thomas Gosse on 06/01/2021.
//

import SwiftUI
import MapKit

class Landmark: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var countryCode: String?
    var pointOfInterestCategory: MKPointOfInterestCategory?
    var id: UUID
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D,
         countryCode: String?, pointOfInterestCategory: MKPointOfInterestCategory?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.countryCode = countryCode
        self.pointOfInterestCategory = pointOfInterestCategory
        self.id = UUID()
    }
    
    init(_ landmark: LocalLandmark) {
        self.coordinate = CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude)
        self.title = landmark.title
        self.subtitle = landmark.subtitle
        self.countryCode = landmark.countryCode
        self.id = landmark.id ?? UUID()
        if let poiCategory = landmark.pointOfInterestCategory {
            self.pointOfInterestCategory = MKPointOfInterestCategory(rawValue: poiCategory)
        }
    }
}

class SearchLandmark: Landmark {}

class UserLandmark: Landmark {
    var visited: Bool

    override init(_ landmark: LocalLandmark) {
        self.visited = landmark.visited
        super.init(landmark)
    }
}
