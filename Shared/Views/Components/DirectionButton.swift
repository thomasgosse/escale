//
//  DirectionButton.swift
//  Escale
//
//  Created by Thomas Gosse on 25/01/2021.
//

import SwiftUI
import MapKit


struct DirectionButton: View {
    var landmark: LocalLandmark
    
    var body: some View {
        Button(action: {
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            let coordinate = CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude)
            let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            item.name = landmark.title
            item.openInMaps(launchOptions: options)
        }, label: {
            HStack {
                Text("Obtenir l'itinéraire")
                Image(systemName: "car")
            }
        })
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(.label)
    }
}
