#!/bin/sh

#  skip-backup.sh
#  
#
#  Created by Markus Tratschitt on 03.04.25.
#  
osascript -e 'display dialog "Backup wirklich überspringen?" buttons {"Abbrechen", "Überspringen"} default button "Abbrechen"' | grep "Überspringen" && tmutil skip
