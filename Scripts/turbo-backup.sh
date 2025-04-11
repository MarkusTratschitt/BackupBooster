#!/bin/bash

# Turbo Time Machine Monitor Script für macOS

# 🔧 Konfigurationsdatei laden (optional)
CONFIG_FILE="$HOME/Library/Application Support/turbo-backup/config.conf"
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# 📦 Backup-Ziel automatisch erkennen, falls nicht gesetzt
if [[ -z "$BACKUP_MOUNT" ]]; then
  BACKUP_MOUNT=$(tmutil destinationinfo | awk -F'"' '/Mount Point/ {print $2}' | head -n 1)
fi

# 🧠 Disk-Name aus Pfad extrahieren (nur Info)
BACKUP_DISK_NAME=$(basename "$BACKUP_MOUNT")

# 📁 Logfile definieren (Standard oder aus config)
LOGFILE="${LOGFILE:-$HOME/Library/Logs/turbo-backup.log}"
MAX_LOG_LINES="${MAX_LOG_LINES:-500}"

# ❗ Fehler, wenn kein Ziel gefunden
if [[ -z "$BACKUP_MOUNT" || ! -d "$BACKUP_MOUNT" ]]; then
  echo "❌ Kein Time Machine Ziel gefunden! Ist das Volume eingehängt?"
  exit 1
fi

# ⚙️ Spotlight deaktivieren (optional)
if [[ "$DISABLE_SPOTLIGHT" != "false" ]]; then
  echo "⚙️  Spotlight Indexierung deaktivieren..."
  osascript -e 'do shell script "mdutil -i off \"'"$BACKUP_MOUNT"'\"" with administrator privileges'
fi

# 🐢 Throttle deaktivieren (optional)
if [[ "$DISABLE_THROTTLE" != "false" ]]; then
  echo "🚀 Time Machine Throttle deaktivieren..."
  osascript -e 'do shell script "sysctl debug.lowpri_throttle_enabled=0" with administrator privileges'
fi

echo "📡 Backup-Monitor gestartet. Drücke STRG+C zum Beenden."
echo "------------------------------------------------------"

# 📓 Logging-Funktion mit Rotation
log_entry() {
  local timestamp
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "$timestamp|$PHASE|$PERCENT_DISPLAY%|$TIME_LEFT Sek." >> "$LOGFILE"
  tail -n "$MAX_LOG_LINES" "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
}

# 🔁 Monitoring-Schleife
while true; do
  STATUS=$(tmutil status 2>/dev/null)

  if [[ -z "$STATUS" ]]; then
    echo "⏹️  Kein aktives Backup gefunden. Warte 10 Sekunden..."
  else
    PHASE=$(echo "$STATUS" | awk -F'= ' '/BackupPhase/ {gsub(/["; ]/, "", $2); print $2}')
    PERCENT=$(echo "$STATUS" | awk -F'= ' '/Percent =/ {gsub(/["; ]/, "", $2); print $2}')
    TIME_LEFT=$(echo "$STATUS" | awk -F'= ' '/TimeRemaining/ {gsub(/["; ]/, "", $2); printf("%.0f", $2)}')

    if [[ -n "$PERCENT" ]]; then
      PERCENT_DISPLAY=$(echo "$PERCENT * 100" | LC_NUMERIC=C bc | LC_NUMERIC=C xargs printf "%.1f")
    else
      PERCENT_DISPLAY="?"
    fi

    echo "🌀 Phase: $PHASE | 📈 Fortschritt: $PERCENT_DISPLAY% | ⏳ Verbleibend: $TIME_LEFT Sek."
    log_entry

    if [[ "$PERCENT_DISPLAY" != "?" ]] && (( $(echo "$PERCENT_DISPLAY >= 99.9" | bc -l) )); then
      osascript -e 'display notification "Backup abgeschlossen!" with title "✅ Time Machine" sound name "Submarine"'
      echo "✅ Backup abgeschlossen – Notification wurde gesendet."
      break
    fi
  fi

  sleep 10
done
