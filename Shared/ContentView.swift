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
    var body: some View {
        TabView {
            MapTabView()
                .tabItem {
                    Image(systemName:"map.fill")
                    Text("Carte")
                }
                .accentColor(.blue)
            ListTabView()
                .tabItem {
                    Image(systemName:"mappin")
                    Text("Liste")
                }
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
