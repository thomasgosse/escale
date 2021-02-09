//
//  SettingsSummary.swift
//  Escale
//
//  Created by Thomas Gosse on 08/02/2021.
//

import SwiftUI


struct SettingsSummaryView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 7) {
                TextLabel("Thomas Gosse", "Nom")
                Divider()
                TextLabel("À plat", "Type de carte")
                Divider()
                TextLabel("Lorsque l'app est active", "Service de localisation")
            }
            .cardStyle(paddingX: 15, paddingY: 10)
            StatsView()
                .padding([.leading, .trailing, .bottom])
            
            NavigationLink("Contribuer", destination: Text("Contribution"))
                .cardStyle(paddingX: 15, paddingY: 15)
        }
    }
}
