//
//  MapTypeCard.swift
//  Escale
//
//  Created by Thomas Gosse on 12/02/2021.
//

import SwiftUI
import MapKit


struct MapTypeCardView: View {
    @Environment(\.colorScheme) var colorScheme
    var mapType: MKMapType
    @Binding var selected: MKMapType
    
    var body: some View {
        MapPreview(mapType: mapType)
            .frame(width: 100, height: 140)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selected == mapType ? Color.purple :
                                colorScheme == .dark
                                ? Color.secondarySystemBackground
                                :Color.systemBackground,
                            lineWidth: 4)
            )
            .onTapGesture {
                selected = mapType
            }
    }
}

private struct MapPreview: UIViewRepresentable {
    var mapType: MKMapType
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.mapType = mapType
        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 54, longitude: 15),
                span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)),
            animated: false
        )
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
}

