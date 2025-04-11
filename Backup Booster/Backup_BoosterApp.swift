//
//  Backup_BoosterApp.swift
//  Backup Booster
//
//  Created by Markus Tratschitt on 11.04.25.
//

import SwiftUI

@main
struct Backup_Booster: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("appMode") var appMode: String = "menubar"

    var body: some Scene {
        WindowGroup {
            if appMode == "window" {
                MainView()
            } else {
                EmptyView()
            }
        }

        Settings {
            SettingsView()
        }

        // ➕ App-Menü-Befehle
        Commands {
            CommandGroup(replacing: .appSettings) {
                Button("⚙️ Einstellungen…") {
                    NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                }
            }

            CommandMenu("🌀 Backup Booster") {
                Button("Dashboard anzeigen") {
                    showDashboard()
                }
                .keyboardShortcut("d", modifiers: [.command, .shift])
            }
        }
    }

    // Zeigt das Fenster mit MainView, wenn z. B. aus dem Menü aufgerufen
    private func showDashboard() {
        let window = NSApplication.shared.windows.first { $0.contentView is NSHostingView<MainView> }
        window?.makeKeyAndOrderFront(nil)
    }
}




