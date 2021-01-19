//
//  LandmarkDetail.swift
//  travelapp
//
//  Created by Thomas Gosse on 15/01/2021.
//

import SwiftUI
import MapKit

struct LandmarkDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var mapState: MapState

    @ObservedObject var landmark: LocalLandmark
    @State var selectedColor = 0
    
    var body: some View {
        if !landmark.isFault {
            VStack {
                DetailViewMap(landmark)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 200)
                Text(landmark.title!)
                if landmark.visited {
                    Text("True")
                } else {
                    Text("False")
                }
                Button("Visited??") {
                    landmark.visited.toggle()
                    do {
                        try viewContext.save()
                        mapState.modifiedLandmark = landmark
                    } catch {
                        // let nsError = error as NSError
                    }
                }
                Spacer()
            }.onDisappear {
                mapState.modifiedLandmark = nil
            }
        }
    }
}

struct DetailViewMap: UIViewRepresentable {
    private var landmark: Landmark
    
    init(_ localLandmark: LocalLandmark) {
        self.landmark = Landmark(localLandmark)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.setRegion(MKCoordinateRegion(center: landmark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)), animated: false)
        mapView.addAnnotation(landmark)
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
}
