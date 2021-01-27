//
//  LandmarkSummary.swift
//  travelapp
//
//  Created by Thomas Gosse on 22/01/2021.
//

import SwiftUI


struct LandmarkSummaryView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject var landmark: LocalLandmark
    
    @State private var isShowingDetailView = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Informations du lieu")
                .textCase(.uppercase)
                .font(.footnote)
                .foregroundColor(.secondaryLabel)
                .padding([.leading])
            VStack(alignment: .leading, spacing: 7) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Nom").font(.subheadline).foregroundColor(.secondaryLabel)
                    Text(landmark.title)
                }
                Divider()
                VStack(alignment: .leading, spacing: 3) {
                    Text("Complément").font(.subheadline).foregroundColor(.secondaryLabel)
                    Text(landmark.subtitle)
                }
                Divider()

                VStack(alignment: .leading, spacing: 3) {
                    Text("Lien").font(.subheadline).foregroundColor(.secondaryLabel)
                    if let url = landmark.url {
                        Link(url.absoluteString, destination: url)
                        if !UIApplication.shared.canOpenURL(url) {
                            HStack {
                                Image(systemName:"exclamationmark.triangle").foregroundColor(.yellow)
                                Text("Ce lien n'est pas valide")
                            }
                        }
                    } else {
                        Text("")
                    }
                }
                Divider()

                VStack(alignment: .leading, spacing: 3) {
                    Text("Note personnelle").font(.subheadline).foregroundColor(.secondaryLabel)
                    Text(landmark.personalNote)
                }
            }
            .cardStyle(paddingX: 15, paddingY: 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

