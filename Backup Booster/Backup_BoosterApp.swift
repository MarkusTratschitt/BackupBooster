//
//  Backup_BoosterApp.swift
//  Backup Booster
//
//  Created by Markus Tratschitt on 11.04.25.
//

import SwiftUI

@main
struct Backup_BoosterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
