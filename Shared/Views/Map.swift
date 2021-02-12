//
//  MapView.swift
//  Escale
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var mapState: MapState
    @Binding var mapType: MKMapType

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LocalLandmark.title, ascending: true)])
    private var localLandmarks: FetchedResults<LocalLandmark>
    
    @Binding var searchLandmarks: [SearchLandmark]
    var didCenterToUserLocation = false
    
    class Coordinator: NSObject, MKMapViewDelegate {
        private var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if let annotation = views.first?.annotation {
                if annotation is MKUserLocation && !self.parent.didCenterToUserLocation  {
                    let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                    mapView.setRegion(region, animated: true)
                    self.parent.didCenterToUserLocation = true
                    return
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let landmark = annotation as? Landmark {
                return getLandmarkAnnotationView(landmark, mapView, annotation)
            } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
                return getClusterAnnotationView(mapView, clusterAnnotation)
            } else {
                return nil
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.parent.mapState.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let landmark = view.annotation as? SearchLandmark {
                self.parent.searchLandmarks = []
                createLocalLandmark(landmark: landmark)
            } else if view.annotation is UserLandmark {
                print("Informations //TODO")
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.mapType = mapType
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if view.mapType != mapType {
            view.mapType = mapType
        }
        view.showsUserLocation = true
        
        if let modifiedLandmark = mapState.modifiedLandmark {
            updateLandmarkOnMap(view, modifiedLandmark, false)
            mapState.modifiedLandmark = nil
        }
        
        if let focusLandmark = mapState.focusLandmark {
            let center = CLLocationCoordinate2D(latitude: focusLandmark.latitude, longitude: focusLandmark.longitude)
            view.setRegion(
                MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
                animated: false
            )
            mapState.focusLandmark = nil
        }
        
        if let deletedLandmark = mapState.deletedLandmark {
            updateLandmarkOnMap(view, deletedLandmark, true)
            mapState.deletedLandmark = nil
            try? viewContext.save()
        }
        
        if searchLandmarks.count == 0 {
            view.removeAnnotations(view.annotations.filter { $0 is SearchLandmark })
        }
        
        let newSearchLandmarks = filterAlreadyAddedLandmarks(landmarks: searchLandmarks, mapAnnotations: view.annotations)
        view.addAnnotations(newSearchLandmarks)
        centerOnNewLandmarks(newSearchLandmarks, view)
        let userLandmarks = localLandmarks.map { UserLandmark($0) }
        let newUserLandmarks = filterAlreadyAddedLandmarks(landmarks: userLandmarks, mapAnnotations: view.annotations)
        view.addAnnotations(newUserLandmarks)
    }
}

extension MapView {
    private func centerOnNewLandmarks(_ newLandmarks: [Landmark], _ view: MKMapView) {
        if newLandmarks.count == 0 { return }
        if newLandmarks.count == 1, let landmark = newLandmarks.first {
            let region = MKCoordinateRegion(center: landmark.coordinate, span: self.mapState.region.span)
            view.setRegion(region, animated: true)
            view.selectAnnotation(landmark, animated: true)
        } else if newLandmarks.count > 1 {
            view.setRegion(getCenteredRegion(landmarks: newLandmarks), animated: true)
        }
    }
    
    private func filterAlreadyAddedLandmarks(landmarks: [Landmark], mapAnnotations: [MKAnnotation]) -> [Landmark] {
        return landmarks.filter { (landmark) -> Bool in
            return !mapAnnotations.contains {
                if let mapLandmark = $0 as? Landmark {
                    return mapLandmark.id == landmark.id
                } else {
                    return false
                }
            }
        }
    }
    
    private func updateLandmarkOnMap(_ view: MKMapView, _ modifiedLandmark: LocalLandmark, _ deleted: Bool) {
        if let annotationToRemove = view.annotations.first(where: {(annotation) -> Bool in
            if let a = annotation as? UserLandmark {
                return a.id == modifiedLandmark.id
            } else {
                return false
            }
        }) as? UserLandmark {
            view.removeAnnotation(annotationToRemove)
            if !deleted {
                view.addAnnotation(UserLandmark(modifiedLandmark))
            }
        }
    }
    
    private func getCenteredRegion(landmarks: [Landmark]) -> MKCoordinateRegion {
        var maxLat: Double = -90.0
        var maxLong: Double = -180.0
        var minLat: Double = 90.0
        var minLong: Double = 180.0
        
        landmarks.forEach { (landmark) in
            let location = landmark.coordinate
            
            if (location.latitude < minLat) {
                minLat = location.latitude;
            }
            
            if (location.longitude < minLong) {
                minLong = location.longitude;
            }
            
            if (location.latitude > maxLat) {
                maxLat = location.latitude;
            }
            
            if (location.longitude > maxLong) {
                maxLong = location.longitude;
            }
        }
        
        let center = CLLocationCoordinate2DMake((maxLat + minLat) * 0.5, (maxLong + minLong) * 0.5);
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLong - minLong) * 1.5)
        return MKCoordinateRegion(center: center, span: span)
    }
}

extension MapView.Coordinator {
    private func getMarkerAnnotation(_ mapView: MKMapView, _ annotation: MKAnnotation, _ identifier: String) -> MKMarkerAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    private func getLandmarkAnnotationView(_ landmark: Landmark, _ mapView: MKMapView, _ annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = landmark is UserLandmark ? "UserAnnotation" : "SearchAnnotation"
        let annotationView = getMarkerAnnotation(mapView, annotation, identifier)
        if landmark is SearchLandmark {
            annotationView?.markerTintColor = .systemIndigo
            annotationView?.clusteringIdentifier = identifier
            annotationView?.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        } else if let l = landmark as? UserLandmark {
            annotationView?.markerTintColor = l.visited ? .systemGray : .purple
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.displayPriority = .required
            annotationView?.clusteringIdentifier = identifier
            if l.visited {
                annotationView?.clusteringIdentifier = "SearchAnnotationVisited"
            }
        }
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    private func getClusterAnnotationView(_ mapView: MKMapView, _ clusterAnnotation: MKClusterAnnotation) -> MKMarkerAnnotationView? {
        let identifier = clusterAnnotation.memberAnnotations.first is UserLandmark ? "UserAnnotationCluster" : "SearchAnnotationCluster"
        let annotationView = getMarkerAnnotation(mapView, clusterAnnotation, identifier)
        if identifier == "SearchAnnotationCluster" {
            annotationView?.markerTintColor = .systemIndigo
        } else if identifier == "UserAnnotationCluster" {
            if let landmark = clusterAnnotation.memberAnnotations.first as? UserLandmark {
                annotationView?.markerTintColor = landmark.visited ? .gray : .purple
                annotationView?.displayPriority = .required
            }
           
        }
        return annotationView
    }
    
    private func createLocalLandmark(landmark: SearchLandmark) {
        let localLandmark = LocalLandmark(context: self.parent.viewContext)
        localLandmark.id = landmark.id
        localLandmark.countryCode = landmark.countryCode
        localLandmark.latitude = landmark.coordinate.latitude
        localLandmark.longitude = landmark.coordinate.longitude
        localLandmark.pointOfInterestCategory = landmark.pointOfInterestCategory?.rawValue
        localLandmark.title = landmark.title ?? ""
        localLandmark.subtitle = landmark.subtitle ?? ""
        localLandmark.visited = false
        try? self.parent.viewContext.save()
    }
}
