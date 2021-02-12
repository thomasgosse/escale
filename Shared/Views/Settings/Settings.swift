//
//  SettingsView.swift
//  Escale
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI
import MapKit


struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject private var locationManager: LocationManager
    @ObservedObject private var userSettings: UserSettings
    
    @State private var editMode = false
    @State private var draftMapType: MKMapType
    @State private var draftUserName: String = ""
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)])
    private var user: FetchedResults<User>
    
    private var userName: String {
        user.first?.name ?? ""
    }
    
    init(_ userSettings: UserSettings, _ locationManager: LocationManager) {
        self.locationManager = locationManager
        self.userSettings = userSettings
        _draftMapType = .init(initialValue: userSettings.mapType)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                if colorScheme == .dark {
                    Color.systemBackground.edgesIgnoringSafeArea(.all)
                } else {
                    Color.secondarySystemBackground.edgesIgnoringSafeArea([.all])
                }
                if !editMode {
                    SettingsSummaryView(locationManager.status, locationManager.statusAsString, userSettings.mapTypeAsString, userName)
                        .transition(.slide)
                        .animation(.default)
                        .zIndex(2)
                } else {
                    SettingsEditorView(draftMapType: $draftMapType, userName: $draftUserName)
                        .transition(.slide)
                        .animation(.default)
                        .zIndex(1)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if editMode {
                        Button("Annuler", action: {
                            withAnimation {
                                draftMapType = userSettings.mapType
                                draftUserName = userName
                                self.editMode.toggle()
                            }
                        })
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(editMode ? "Done" : "Edit", action: {
                        withAnimation {
                            if editMode {
                                userSettings.mapType = draftMapType
                                self.saveOrCreateUser(draftUserName)
                            }
                            self.editMode.toggle()
                        }
                    })
                }
            }
            .navigationTitle("Profil")
            .onAppear {
                draftUserName = userName
            }
        }
    }
    
    private func saveOrCreateUser(_ userName: String) {
        if let user = user.first {
            user.name = userName
        } else {
            let user = User(context: self.viewContext)
            user.name = userName
        }
        try? viewContext.save()
    }
}
