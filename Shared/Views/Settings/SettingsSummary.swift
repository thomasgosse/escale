//
//  SettingsSummary.swift
//  Escale
//
//  Created by Thomas Gosse on 08/02/2021.
//

import SwiftUI
import MapKit


struct SettingsSummaryView: View {
    @State private var userName: String
    @State var status: CLAuthorizationStatus?
    @State var statusAsString: String
    @State var mapTypeAsString: String
    
    init(_ status: CLAuthorizationStatus?, _ statusAsString: String, _ mapTypeAsString: String, _ userName: String) {
        _status = .init(initialValue: status)
        _statusAsString = .init(initialValue: statusAsString)
        _mapTypeAsString = .init(initialValue: mapTypeAsString)
        _userName = .init(initialValue: userName)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 7) {
                TextLabel(userName, "Nom d'utilisateur")
                Divider()
                TextLabel(mapTypeAsString, "Type de carte")
                Divider()
                VStack(alignment: .leading, spacing: 3) {
                    Text("Accès à votre position").font(.subheadline).foregroundColor(.secondaryLabel)
                    HStack {
                        Text(statusAsString)
                        if status == .authorizedAlways || status == .authorizedWhenInUse {
                            Image(systemName: "location.fill").foregroundColor(.purple)
                        } else {
                            Image(systemName: "location.slash.fill").foregroundColor(.purple)
                        }
                    }
                }
            }
            .cardStyle(paddingX: 15, paddingY: 10)
            StatsView()
                .padding([.leading, .trailing, .bottom])
            NavigationLink("Contribuer", destination: Text("Contribution"))
                .cardStyle(paddingX: 15, paddingY: 15)
        }
    }
}
