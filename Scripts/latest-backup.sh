#!/bin/sh

#  latest-backup.sh
#  
#
#  Created by Markus Tratschitt on 03.04.25.
#  
LATEST=$(tmutil latestbackup 2>/dev/null)

if [[ -z "$LATEST" ]]; then
  osascript -e 'display dialog "Kein abgeschlossenes Backup gefunden." with title "Time Machine" buttons {"OK"} default button 1'
else
  DATUM=$(basename "$LATEST" | sed 's/\([0-9]*\)-\([0-9]*\)-\([0-9]*\)-\([0-9]*\)\([0-9]*\)\([0-9]*\)/\1-\2-\3 \4:\5/')
  osascript -e "display dialog \"🕓 Letztes Backup:\n$DATUM\n📂 Pfad:\n$LATEST\" with title \"Time Machine\" buttons {\"OK\"} default button 1"
fi
