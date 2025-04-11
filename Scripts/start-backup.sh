#!/bin/sh

#  start-backup.sh
#  
#
#  Created by Markus Tratschitt on 03.04.25.
#  
osascript -e 'display dialog "Time Machine Backup jetzt starten?" buttons {"Abbrechen", "Starten"} default button "Abbrechen"' | grep "Starten" && tmutil startbackup --auto
