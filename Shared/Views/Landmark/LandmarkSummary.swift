//
//  LandmarkSummary.swift
//  Escale
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
                TextLabel(landmark.title, "Nom")
                Divider()
                TextLabel(landmark.subtitle, "Complément")
                if let url = landmark.url, !url.absoluteString.isEmpty {
                    Divider()
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Lien").font(.subheadline).foregroundColor(.secondaryLabel)
                        Link(url.absoluteString, destination: url)
                        if !UIApplication.shared.canOpenURL(url) {
                            HStack {
                                Image(systemName:"exclamationmark.triangle").foregroundColor(.yellow)
                                Text("Ce lien n'est pas valide")
                            }
                        }
                    }
                }
                
                if !landmark.personalNote.isEmpty {
                    Divider()
                    TextLabel(landmark.personalNote, "Note personnelle")
                }
            }
            .cardStyle(paddingX: 15, paddingY: 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

