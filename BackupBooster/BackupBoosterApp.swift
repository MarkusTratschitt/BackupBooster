//
//  BackupBoosterApp.swift
//  BackupBooster
//
//  Created by Markus Tratschitt on 11.04.25.
//

import SwiftUI

@main
struct BackupBooster: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("appMode") var appMode: String = "menubar"
    
    var body: some Scene {
        // 🪟 Hauptfenster – nur wenn Fenster-Modus aktiv ist
        WindowGroup {
            if appMode == "window" {
                MainView()
            } else {
                EmptyView() // keine Anzeige im Menüleistenmodus
            }
        }
        
        // ⚙️ Einstellungen (SwiftUI Settings-Standard)
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("⚙️ Einstellungen öffnen") {
                    NSApplication.shared.sendAction(
                        Selector(("showPreferencesWindow:")),
                        to: nil,
                        from: nil
                    )
                }
            }
            
            CommandMenu("🌀 Backup Booster") {
                Button("Dashboard anzeigen") {
                    appDelegate.showDashboard()
                }
                .keyboardShortcut("d", modifiers: [.command, .shift])
            }
        }
        
        Settings {
            SettingsView()
        }
    }
}
