//
//  SettingsEditor.swift
//  Escale
//
//  Created by Thomas Gosse on 11/02/2021.
//

import SwiftUI
import MapKit

struct SettingsEditorView: View {
    @Binding var draftMapType: MKMapType
    @Binding var userName: String
    
    var body: some View {
        List {
            Section(header: Text("Nom d'utilisateur")) {
                TextField("Nom d'utilisateur", text: $userName)
            }
            Section(header: Text("Type de carte")) {
                MapTypeSelectionView(draftMapType: $draftMapType)
            }
            Section(header: Text("Accès à votre position")) {
                if let url = NSURL(string: UIApplication.openSettingsURLString) {
                    Link(destination: url as URL) {
                        HStack(alignment: .center, spacing: 5) {
                            Text("Modifier dans les réglages")
                            Image(systemName: "gear")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
