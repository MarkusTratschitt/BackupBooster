#!/bin/sh

#  show-status.sh
#  
#
#  Created by Markus Tratschitt on 03.04.25.
#  
#!/bin/bash

LOGFILE="$HOME/Library/Logs/BackupBooster.log"
LATEST=$(tail -n 1 "$LOGFILE")

if [[ -z "$LATEST" ]]; then
  osascript -e 'display dialog "Keine Statusdaten im Logfile verfügbar." with title "Time Machine Status" buttons {"OK"} default button 1'
else
  PHASE=$(echo "$LATEST" | cut -d'|' -f2)
  # Letztes abgeschlossenes Backup
    LATEST_BACKUP=$(tmutil latestbackup 2>/dev/null)
    if [[ -n "$LATEST_BACKUP" ]]; then
      LAST_DATE=$(basename "$LATEST_BACKUP" | sed 's/\([0-9]*\)-\([0-9]*\)-\([0-9]*\)-\([0-9]*\)\([0-9]*\)\([0-9]*\)/\1-\2-\3 \4:\5/')
    else
      LAST_DATE="Kein abgeschlossenes Backup gefunden"
      LATEST_BACKUP="–"
    fi
  PROGRESS=$(echo "$LATEST" | cut -d'|' -f3)
  TIMELEFT=$(echo "$LATEST" | cut -d'|' -f4)
  TIMESTAMP=$(echo "$LATEST" | cut -d'|' -f1)

MSG="🌀 Phase: $PHASE
📈 Fortschritt: $PROGRESS
⏳ Verbleibend: $TIMELEFT
🕒 Zuletzt aktualisiert: $TIMESTAMP

🕓 Letztes Backup: $LAST_DATE
📂 Pfad: $LATEST_BACKUP"


  osascript -e "display dialog \"$MSG\" with title \"📊 Time Machine Status\" buttons {\"OK\"} default button 1"
fi
