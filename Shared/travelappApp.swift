//
//  travelappApp.swift
//  Shared
//
//  Created by Thomas Gosse on 03/01/2021.
//

import SwiftUI


@main
struct travelappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
