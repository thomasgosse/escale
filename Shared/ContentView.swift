//
//  ContentView.swift
//  Shared
//
//  Created by Thomas Gosse on 03/01/2021.
//

import SwiftUI
import CoreData
import MapKit
import Combine


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
        .environmentObject(LocationManager())
        .environmentObject(UserSettings())
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

class UserSettings: ObservableObject {
    @Published var mapType: MKMapType {
        didSet {
            self.mapTypeAsString = UserSettings.getStringFromMapType(mapType)
            UserDefaults.standard.set(mapType.rawValue, forKey: "mapType")
        }
    }
    
    @Published var mapTypeAsString: String
    
    init() {
        let mapTypeString = UserDefaults.standard.string(forKey: "mapType") ?? ""
        let mapTypeRaw = UInt(mapTypeString) ?? 0
        self.mapType = MKMapType(rawValue: mapTypeRaw) ?? .standard
        self.mapTypeAsString = UserSettings.getStringFromMapType(MKMapType(rawValue: mapTypeRaw) ?? .standard)
    }
    
    static func getStringFromMapType(_ mapType: MKMapType) -> String {
        switch mapType {
        case .standard:
            return "Standard"
        case .satelliteFlyover:
            return "Satellite 3D"
        case .satellite:
            return "Satellite"
        default:
            return "Autre"
        }
    }
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
