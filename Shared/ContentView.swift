//
//  ContentView.swift
//  Shared
//
//  Created by Thomas Gosse on 03/01/2021.
//

import SwiftUI
import CoreData
import MapKit


struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapTabView()
                .tabItem {
                    Image(systemName:"map.fill")
                    Text("Carte")
                }
                .tag(0)
                .accentColor(.blue)
            ListTabView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName:"mappin")
                    Text("Liste")
                }
                .tag(1)
                .accentColor(.purple)
        }
        .accentColor(.label)
        .environmentObject(MapState())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class MapState: ObservableObject {
    @Published var modifiedLandmark: LocalLandmark?
    @Published var deletedLandmark: LocalLandmark?
    @Published var focusLandmark: LocalLandmark?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.419, longitude: -3.691), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}

extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = .flexibleWidth
        tabBar.insertSubview(blurView, at: 0)
    }
}
