#!/bin/bash
# <xbar.title>Turbo Time Machine</xbar.title>
# <xbar.version>v1.4</xbar.version>
# <xbar.author>Markus Tratschitt</xbar.author>
# <xbar.desc>Time Machine überwachen & steuern</xbar.desc>
# <xbar.refreshTime>10s</xbar.refreshTime>
# <xbar.dependencies>tmutil, bc</xbar.dependencies>

STATUS=$(tmutil status 2>/dev/null)
LATEST=$(tmutil latestbackup 2>/dev/null)

if [[ -n "$LATEST" ]]; then
  LAST_DATE=$(basename "$LATEST" | sed 's/\([0-9]*\)-\([0-9]*\)-\([0-9]*\)-\([0-9]*\)\([0-9]*\)\([0-9]*\)/\1.\2. \4:\5/')
else
  LAST_DATE="–"
fi

if [[ -z "$STATUS" ]]; then
  echo "🌀 TM: ⏹️ | Letztes: $LAST_DATE"
  echo "---"
  echo "Kein aktives Backup"
else
  PHASE=$(echo "$STATUS" | awk -F'= ' '/BackupPhase/ {gsub(/["; ]/, "", $2); print $2}')
  PERCENT=$(echo "$STATUS" | awk -F'= ' '/Percent =/ {gsub(/["; ]/, "", $2); print $2}')

  if [[ "$PHASE" == "Thinning" || "$PHASE" == "LazyThinning" ]]; then
    echo "🧹 TM: Aufräumen | Letztes: $LAST_DATE"
    echo "---"
    echo "Löscht alte Snapshots, um Platz zu schaffen."
  elif [[ -z "$PERCENT" ]]; then
    echo "🔍 TM: Vorbereitung | Letztes: $LAST_DATE"
    echo "---"
    echo "Sucht nach Änderungen oder initialisiert Backup..."
  else
    PERCENT_DISPLAY=$(echo "$PERCENT * 100" | LC_NUMERIC=C bc | LC_NUMERIC=C xargs printf "%.1f")
    echo "🌀 TM: ${PERCENT_DISPLAY}% | Letztes: $LAST_DATE"
    echo "---"
    echo "Phase: $PHASE"
    echo "Fortschritt: $PERCENT_DISPLAY%"

    if (( $(echo "$PERCENT_DISPLAY >= 99.9" | bc -l) )); then
      osascript -e 'display notification "Backup abgeschlossen!" with title "✅ Time Machine" sound name "Submarine"'
    fi
  fi
fi

echo "---"
echo "📦 Neues Backup starten | bash=\"$HOME/TurboMonitor/Scripts/start-backup.sh\" terminal=false"
echo "🛑 Backup abbrechen | bash=\"$HOME/TurboMonitor/Scripts/stop-backup.sh\" terminal=false"
echo "⏸️ Backup pausieren | bash=\"$HOME/TurboMonitor/Scripts/pause-backup.sh\" terminal=false"
echo "▶️ Backup fortsetzen | bash=\"$HOME/TurboMonitor/Scripts/resume-backup.sh\" terminal=false"
echo "⏭️ Backup überspringen | bash=\"$HOME/TurboMonitor/Scripts/skip-backup.sh\" terminal=false"
echo "---"
echo "📈 Boost starten | bash=\"$HOME/TurboMonitor/Scripts/turbo-backup.sh\" terminal=true"
echo "🔧 Werkzeuge"
echo "🧹 Alte Backups löschen | bash=\"$HOME/TurboMonitor/Scripts/clean-old-backups.sh\" terminal=true"
echo "📁 Einzelnes Backup löschen | bash=\"$HOME/TurboMonitor/Scripts/delete-single-backup.sh\" terminal=true"
echo "🐢 Throttle zurücksetzen | bash=\"$HOME/TurboMonitor/Scripts/reset-throttle.sh\" terminal=true"
echo "🧲 Spotlight aktivieren | bash=\"$HOME/TurboMonitor/Scripts/enable-spotlight.sh\" terminal=true"
echo "---"
echo "📜 Status anzeigen | bash=\"$HOME/TurboMonitor/Scripts/show-status.sh\" terminal=false"
echo "🕓 Letztes Backup anzeigen | bash=\"$HOME/TurboMonitor/Scripts/latest-backup.sh\" terminal=false"
echo "📖 Log anzeigen | bash=\"$HOME/TurboMonitor/Scripts/open-log.sh\" terminal=false"
echo "🧼 Log löschen | bash=\"$HOME/TurboMonitor/Scripts/clean-log.sh\" terminal=false"
echo "---"
echo "🔄 Neu laden | refresh=true"
