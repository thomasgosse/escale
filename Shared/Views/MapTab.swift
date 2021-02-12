//
//  MapTab.swift
//  Escale
//
//  Created by Thomas Gosse on 06/01/2021.
//

import SwiftUI
import MapKit


struct MapTabView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State var searchLandmarks: [SearchLandmark] = []
    @State var userLandmarks: [UserLandmark] = []

    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapView(mapType: $userSettings.mapType, searchLandmarks: $searchLandmarks)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            MapOverlay(searchLandmarks: $searchLandmarks)
        }
    }
}

struct MapOverlay: View {
    @EnvironmentObject var mapState: MapState
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var locationManager: LocationManager
    @State var isSettingsPresented: Bool = false
    @State var isSearchPresented: Bool = false
    @State var query: String = ""
    
    @Binding var searchLandmarks: [SearchLandmark]
    
    func settingsAction () -> Void { isSettingsPresented = true }
    func searchAction () -> Void { isSearchPresented = true }
    func deleteAction () -> Void {
        searchLandmarks = []
        query = ""
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            MapButton(
                image: Image(systemName: "person.crop.circle")
                    .font(Font.system(size: 28, weight: .light))
                    .accentColor(.systemGray),
                action: settingsAction
            ) .sheet(isPresented: $isSettingsPresented, content: {
                SettingsView(userSettings, locationManager)
                    .accentColor(.purple)
            })
            .padding(.top, 20)
            HStack(alignment: .center) {
                if query != "" && searchLandmarks.count > 0 {
                    Text(query).padding(7).background(Blur(style: .systemThinMaterial)).cornerRadius(5)
                }
                MapButton(
                    image: LinearGradient(gradient: Gradient(colors: searchLandmarks.count == 0 ? [.purple, .purple] : [.red, .purple]), startPoint: .top, endPoint: .bottom)
                        .mask(searchLandmarks.count == 0
                                ? Image(systemName: "magnifyingglass").font(Font.system(size: 28, weight: .regular))
                                : Image(systemName: "trash").font(Font.system(size: 24, weight: .regular))
                        ),
                    action: searchLandmarks.count == 0 ? searchAction : deleteAction
                ).sheet(isPresented: $isSearchPresented, content: {
                    SearchView(searchLandmarks: $searchLandmarks, isPresented: $isSearchPresented,
                               query: $query, mapState: .constant(mapState))
                        .accentColor(.purple)
                })
            }
            .padding(.bottom, 20)
            .padding(.top, 5)
        }
    }
}
