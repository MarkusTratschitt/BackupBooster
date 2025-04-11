//
//  Backup_BoosterApp.swift
//  Backup Booster
//
//  Created by Markus Tratschitt on 11.04.25.
//

import SwiftUI

@main
struct TurboTimeMachineApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView() // Keine eigene App-Fenster-Szene – nur Menüleiste
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "📊 Status anzeigen", action: #selector(showStatus), keyEquivalent: "S"))
        menu.addItem(NSMenuItem(title: "📖 Log anzeigen", action: #selector(showLog), keyEquivalent: "L"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "📦 Backup starten", action: #selector(startBackup), keyEquivalent: "B"))
        menu.addItem(NSMenuItem(title: "⏸️ Backup pausieren", action: #selector(pauseBackup), keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "▶️ Backup fortsetzen", action: #selector(resumeBackup), keyEquivalent: "R"))
        menu.addItem(NSMenuItem(title: "🛑 Backup abbrechen", action: #selector(stopBackup), keyEquivalent: "Q"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "❌ Beenden", action: #selector(quit), keyEquivalent: "q"))

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "🌀 TM"
        statusItem?.menu = menu
    }

    @objc func showStatus() {
        runScript("show-status.sh")
    }

    @objc func showLog() {
        runScript("open-log.sh")
    }

    @objc func startBackup() {
        runScript("start-backup.sh")
    }

    @objc func pauseBackup() {
        runScript("pause-backup.sh")
    }

    @objc func resumeBackup() {
        runScript("resume-backup.sh")
    }

    @objc func stopBackup() {
        runScript("stop-backup.sh")
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

    func runScript(_ scriptName: String) {
        let scriptPath = "\(NSHomeDirectory())/markustratschitt/TurboMonitor/Scripts/\(scriptName)"
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [scriptPath]
        task.launch()
    }
}
