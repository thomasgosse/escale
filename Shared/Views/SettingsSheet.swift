//
//  SettingsView.swift
//  travelapp
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI


struct SettingsSheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Text("Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Annuler", action: {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
        }
    }
}
