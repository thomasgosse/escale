//
//  LandmarkDetail.swift
//  Escale
//
//  Created by Thomas Gosse on 15/01/2021.
//

import SwiftUI
import MapKit


struct LandmarkDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var mapState: MapState
    @ObservedObject var landmark: LocalLandmark
    
    @Binding var selectedTab: Int
    var titleDisplayMode: NavigationBarItem.TitleDisplayMode
    @State private var isVisited: Bool
    @State private var isModifying = false
    private var onTapMap: (() -> Void)?
        
    init(landmark: LocalLandmark, selectedTab: Binding<Int>? = nil, onTapMap: (() -> Void)? = nil, titleDisplayMode: NavigationBarItem.TitleDisplayMode? = nil) {
        self.landmark = landmark
        _isVisited = .init(initialValue: landmark.visited)
        self._selectedTab = selectedTab ?? .constant(0)
        self.onTapMap = onTapMap
        self.titleDisplayMode = titleDisplayMode ?? .automatic
    }
    
    var body: some View {
        if !landmark.isFault {
            ZStack {
                if colorScheme == .dark {
                    Color.systemBackground.edgesIgnoringSafeArea(.all)
                } else {
                    Color.secondarySystemBackground.edgesIgnoringSafeArea([.all])
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Location")
                            .textCase(.uppercase)
                            .font(.footnote)
                            .foregroundColor(.secondaryLabel)
                            .padding([.leading, .top])
                        VStack(spacing: 15) {
                            LandmarkDetailMapView(localLandmark: landmark)
                                .cornerRadius(12)
                                .frame(height: 300)
                                .onTapGesture {
                                    mapState.focusLandmark = landmark
                                    selectedTab = 0
                                    onTapMap?()
                                }
                            Toggle(isOn: $isVisited.animation()) {
                                if isVisited { Text("Visited singular") }
                                else { Text("Not visited") }
                            }
                            .transition(.opacity)
                            .padding([.leading, .trailing], 5)
                            DirectionButton(landmark: landmark)
                                .padding(.bottom, 10)
                        }
                        .cardStyle(paddingX: 10, paddingY: 10)
                    }
                    LandmarkSummaryView(landmark: landmark)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit", action: { isModifying.toggle() })
                    }
                }
                .sheet(isPresented: $isModifying) {
                    LandmarkEditorView(landmark)
                }
                .navigationBarTitle(landmark.title, displayMode: titleDisplayMode)
                .onWillDisappear { saveModifications() }
            }
        }
    }
    
    private func saveModifications() {
        if landmark.hasChanges || landmark.visited != isVisited {
            landmark.visited = isVisited
            try? viewContext.save()
            mapState.modifiedLandmark = landmark
        }
    }
}

struct LandmarkDetailMapView: UIViewRepresentable {
    @ObservedObject var localLandmark: LocalLandmark
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        let landmark = Landmark(localLandmark)
        mapView.addAnnotation(landmark)
        mapView.setRegion(MKCoordinateRegion(
                            center: landmark.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)),
                          animated: false)
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
}
