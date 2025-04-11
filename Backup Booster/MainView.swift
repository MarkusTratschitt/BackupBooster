//
//  MainView.swift
//  Backup Booster
//
//  Created by Markus Tratschitt on 11.04.25.
//

import SwiftUI

struct MainView: View {
    @State private var phase: String = "–"
    @State private var percent: Double = 0.0
    @State private var timeLeft: String = "–"
    @State private var lastBackup: String = "–"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("🌀 Backup Booster Dashboard")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("📊 Phase: \(phase)")
                ProgressView(value: percent, total: 100)
                    .progressViewStyle(LinearProgressViewStyle())
                Text(String(format: "📈 Fortschritt: %.1f %%", percent))
                Text("⏳ Verbleibend: \(timeLeft) Sek.")
                Text("📂 Letztes Backup: \(lastBackup)")
            }
            
            Divider()
            
            HStack(spacing: 20) {
                Button("📦 Backup starten") {
                    AppDelegate().runScript("start-backup.sh")
                }
                Button("🛑 Stoppen") {
                    AppDelegate().runScript("stop-backup.sh")
                }
                Button("📈 Booster starten") {
                    AppDelegate().runScript("BackupBooster.sh")
                }
                Button("📖 Log anzeigen") {
                    AppDelegate().runScript("open-log.sh")
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 480, height: 340)
        .onAppear {
            updateStatus()
        }
    }
    
    func updateStatus() {
        let statusTask = Process()
        statusTask.launchPath = "/bin/bash"
        statusTask.arguments = ["-c", "tmutil status"]
        
        let pipe = Pipe()
        statusTask.standardOutput = pipe
        statusTask.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            phase = extract(from: output, key: "BackupPhase")
            percent = Double(extract(from: output, key: "Percent")) ?? 0.0
            timeLeft = extract(from: output, key: "TimeRemaining")
        }
        
        // Letztes Backup
        let lastTask = Process()
        lastTask.launchPath = "/bin/bash"
        lastTask.arguments = ["-c", "tmutil latestbackup | xargs basename"]
        
        let lastPipe = Pipe()
        lastTask.standardOutput = lastPipe
        lastTask.launch()
        
        let lastData = lastPipe.fileHandleForReading.readDataToEndOfFile()
        if let last = String(data: lastData, encoding: .utf8) {
            lastBackup = formatBackupDate(last.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    func extract(from text: String, key: String) -> String {
        guard let line = text.components(separatedBy: "\n").first(where: { $0.contains(key) }) else { return "–" }
        return line.components(separatedBy: "=").last?
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: ";", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? "–"
    }
    
    func formatBackupDate(_ raw: String) -> String {
        let pattern = #"(\d{4})-(\d{2})-(\d{2})-(\d{2})(\d{2})"# // YYYY-MM-DD-HHMM
        if let match = raw.range(of: pattern, options: .regularExpression) {
            let date = raw[match]
            let y = date.prefix(4)
            let m = date.dropFirst(5).prefix(2)
            let d = date.dropFirst(8).prefix(2)
            let h = date.dropFirst(11).prefix(2)
            let min = date.dropFirst(13).prefix(2)
            return "\(d).\(m).\(y) – \(h):\(min) Uhr"
        }
        return "-"
    }
}
