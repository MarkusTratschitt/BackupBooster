//
//  SettingsView.swift
//  Backup Booster
//
//  Created by Markus Tratschitt on 11.04.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appMode") private var appMode = "menubar"

    var body: some View {
        Form {
            Section(header: Text("Darstellung")) {
                Picker("App-Modus", selection: $appMode) {
                    Text("Menüleiste").tag("menubar")
                    Text("Fenster").tag("window")
                }
                .pickerStyle(RadioGroupPickerStyle())
                .onChange(of: appMode) { _ in
                    
                    let alert = NSAlert()
                    alert.messageText = "Backup Booster wird neu gestartet"
                    alert.informativeText = "Der App-Modus wird beim Neustart übernommen."
                    alert.alertStyle = .informational
                    alert.addButton(withTitle: "OK")
                    alert.runModal()

                    AppDelegate().restartApp()
                }
            }

            Section(header: Text("System")) {
                Toggle("Beim Systemstart automatisch öffnen", isOn: Binding(
                    get: { UserDefaults.standard.bool(forKey: "launchAtLogin") },
                    set: { newValue in
                        UserDefaults.standard.set(newValue, forKey: "launchAtLogin")
                        AppDelegate().setupLaunchAgent(enabled: newValue)
                        
                        let alert = NSAlert()
                        alert.messageText = "Backup Booster wird neu gestartet"
                        alert.informativeText = "Die Änderung wird beim Neustart der App übernommen."
                        alert.alertStyle = .informational
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                        
                        AppDelegate().restartApp()
                    }
                ))
            }
        }
        .padding()
        .frame(width: 360)
    }
}
