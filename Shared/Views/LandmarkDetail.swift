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
    
    @State var title: String = ""
    @State private var isVisited = false

    var body: some View {
        if !landmark.isFault {
            GeometryReader { geometry in
                Form {
                    Section(header: Text("Localisation")) {
                        DetailViewMap(landmark)
                            .cornerRadius(10)
                            .frame(height: geometry.size.height / 3)
                            .padding([.leading, .trailing], -14)
                    }
                    Section(header: Text("Informations du lieu")) {
                        NavigationLink(destination: Text(landmark.title!)) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Titre").font(.subheadline).foregroundColor(.secondaryLabel)
                                Text(landmark.title!)
                            }
                        }
                        NavigationLink(destination: Text(landmark.subtitle ?? "")) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Sous-titre").font(.subheadline).foregroundColor(.secondaryLabel)
                                Text(landmark.subtitle ?? "")
                            }
                        }
                        Toggle(isOn: $isVisited.animation()) {
                            if isVisited { Text("Visité")
                            } else { Text("Non visité") }
                        }
                        .transition(.opacity)
                        .padding([.top, .bottom], 3)
                    }
                }
                .navigationBarTitle(landmark.title ?? "")
                .onAppear { isVisited = landmark.visited }
                .onWillDisappear {
                    if landmark.visited == isVisited { return }
                    landmark.visited = isVisited
                    do {
                       try viewContext.save()
                       mapState.modifiedLandmark = landmark
                    } catch {
                       // let nsError = error as NSError
                    }
                }
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

