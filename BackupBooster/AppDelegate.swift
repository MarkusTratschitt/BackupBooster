//
//  AppDelegate.swift
//  Backup Booster
//
//  Created by Markus Tratschitt on 11.04.25.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Nur beim ersten Start: Modus wählen
        if !UserDefaults.standard.bool(forKey: "hasLaunched") {
            askForInitialMode()
        }

        // Menüleistenmodus aktivieren
        if UserDefaults.standard.string(forKey: "appMode") == "menubar" {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusItem?.button?.title = "🌀 TM"

            let menu = NSMenu()

            // 📦 Backup Untermenü
            let backupMenu = NSMenu()
            backupMenu.addItem(withTitle: "📦 Backup starten", action: #selector(startBackup), keyEquivalent: "")
            backupMenu.addItem(withTitle: "🛑 Backup abbrechen", action: #selector(stopBackup), keyEquivalent: "")
            backupMenu.addItem(withTitle: "⏸️ Backup pausieren", action: #selector(pauseBackup), keyEquivalent: "")
            backupMenu.addItem(withTitle: "▶️ Backup fortsetzen", action: #selector(resumeBackup), keyEquivalent: "")
            backupMenu.addItem(withTitle: "⏭️ Backup überspringen", action: #selector(skipBackup), keyEquivalent: "")
            backupMenu.addItem(withTitle: "📈 Booster starten", action: #selector(startBooster), keyEquivalent: "")
            menu.setSubmenu(backupMenu, for: menu.addItem(withTitle: "📦 Backup", action: nil, keyEquivalent: ""))

            // 📊 Status Untermenü
            let statusMenu = NSMenu()
            statusMenu.addItem(withTitle: "📊 Status anzeigen", action: #selector(showStatus), keyEquivalent: "")
            statusMenu.addItem(withTitle: "📂 Letztes Backup anzeigen", action: #selector(showLatestBackup), keyEquivalent: "")
            menu.setSubmenu(statusMenu, for: menu.addItem(withTitle: "📊 Status", action: nil, keyEquivalent: ""))

            // 📖 Log Untermenü
            let logMenu = NSMenu()
            logMenu.addItem(withTitle: "📖 Log anzeigen", action: #selector(showLog), keyEquivalent: "")
            logMenu.addItem(withTitle: "🧼 Log löschen", action: #selector(cleanLog), keyEquivalent: "")
            menu.setSubmenu(logMenu, for: menu.addItem(withTitle: "📖 Log", action: nil, keyEquivalent: ""))

            // 🔧 Werkzeuge Untermenü
            let toolsMenu = NSMenu()
            toolsMenu.addItem(withTitle: "🧹 Alte Backups löschen", action: #selector(cleanOldBackups), keyEquivalent: "")
            toolsMenu.addItem(withTitle: "📁 Einzelnes Backup löschen", action: #selector(deleteSingleBackup), keyEquivalent: "")
            toolsMenu.addItem(withTitle: "🐢 Throttle zurücksetzen", action: #selector(resetThrottle), keyEquivalent: "")
            toolsMenu.addItem(withTitle: "🧲 Spotlight aktivieren", action: #selector(enableSpotlight), keyEquivalent: "")
            menu.setSubmenu(toolsMenu, for: menu.addItem(withTitle: "🔧 Werkzeuge", action: nil, keyEquivalent: ""))

            // ❌ Beenden
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "❌ Beenden", action: #selector(quit), keyEquivalent: "x"))

            statusItem?.menu = menu
        }
    }

    func askForInitialMode() {
        let alert = NSAlert()
        alert.messageText = "App-Modus wählen"
        alert.informativeText = "Möchtest du Backup Booster in der Menüleiste oder mit einem Fenster nutzen?"
        alert.addButton(withTitle: "Menüleiste")
        alert.addButton(withTitle: "Fenster")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            UserDefaults.standard.set("menubar", forKey: "appMode")
        } else {
            UserDefaults.standard.set("window", forKey: "appMode")
        }
        
        askForAutostart()
        UserDefaults.standard.set(true, forKey: "hasLaunched")
    }
    
    func askForAutostart() {
        let alert = NSAlert()
        alert.messageText = "Autostart aktivieren?"
        alert.informativeText = "Soll Backup Booster beim Start deines Macs automatisch mitstarten?"
        alert.addButton(withTitle: "Ja")
        alert.addButton(withTitle: "Nein")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            UserDefaults.standard.set(true, forKey: "launchAtLogin")
            setupLaunchAgent(enabled: true)
        } else {
            UserDefaults.standard.set(false, forKey: "launchAtLogin")
        }
    }
    
    func setupLaunchAgent(enabled: Bool) {
        let fileManager = FileManager.default
        let label = "com.markustratschitt.backupbooster"
        let agentPath = "\(NSHomeDirectory())/Library/LaunchAgents/\(label).plist"

        if enabled {
            let executablePath = Bundle.main.bundlePath + "/Contents/MacOS/Backup Booster"

            let plistContent = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" \
            "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
                <key>Label</key>
                <string>\(label)</string>
                <key>ProgramArguments</key>
                <array>
                    <string>\(executablePath)</string>
                </array>
                <key>RunAtLoad</key>
                <true/>
                <key>KeepAlive</key>
                <false/>
            </dict>
            </plist>
            """

            try? plistContent.write(toFile: agentPath, atomically: true, encoding: .utf8)
        } else {
            try? fileManager.removeItem(atPath: agentPath)
        }
    }


    // MARK: - Aktionen

    @objc func showStatus() { runScript("show-status.sh") }
    @objc func showLog() { runScript("open-log.sh") }
    @objc func startBackup() { runScript("start-backup.sh") }
    @objc func pauseBackup() { runScript("pause-backup.sh") }
    @objc func resumeBackup() { runScript("resume-backup.sh") }
    @objc func stopBackup() { runScript("stop-backup.sh") }
    @objc func skipBackup() { runScript("skip-backup.sh") }
    @objc func showLatestBackup() { runScript("latest-backup.sh") }
    @objc func cleanLog() { runScript("clean-log.sh") }
    @objc func cleanOldBackups() { runScript("clean-old-backups.sh") }
    @objc func deleteSingleBackup() { runScript("delete-single-backup.sh") }
    @objc func resetThrottle() { runScript("reset-throttle.sh") }
    @objc func enableSpotlight() { runScript("enable-spotlight.sh") }
    @objc func startBooster() { runScript("BackupBooster.sh") }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: - Script Starter

    func runScript(_ scriptName: String) {
        let path = "\(NSHomeDirectory())/Repositories/Backup Booster/Scripts/\(scriptName)"
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [path]
        task.launch()
    }
    
    func restartApp() {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-n", Bundle.main.bundlePath]
        try? task.run()
        
        NSApplication.shared.terminate(nil)
    }

    func showDashboard() {
        for window in NSApplication.shared.windows {
            if window.contentView is NSHostingView<MainView> {
                window.makeKeyAndOrderFront(nil)
                return
            }
        }
    }

}
