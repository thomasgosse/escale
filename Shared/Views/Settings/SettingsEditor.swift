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
            Section(header: Text("Username")) {
                TextField("Username", text: $userName)
            }
            Section(header: Text("Map type")) {
                MapTypeSelectionView(draftMapType: $draftMapType)
            }
            Section(header: Text("Allow location access")) {
                if let url = NSURL(string: UIApplication.openSettingsURLString) {
                    Link(destination: url as URL) {
                        HStack(alignment: .center, spacing: 5) {
                            Text("Modify in settings")
                            Image(systemName: "gear")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
