//
//  SettingsView.swift
//  Escale
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                if colorScheme == .dark {
                    Color.systemBackground.edgesIgnoringSafeArea(.all)
                } else {
                    Color.secondarySystemBackground.edgesIgnoringSafeArea([.all])
                }
                SettingsSummaryView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Annuler", action: {
                                presentationMode.wrappedValue.dismiss()
                            })
                        }
                    }
            }
            .navigationTitle("Profil")
        }
    }
}
