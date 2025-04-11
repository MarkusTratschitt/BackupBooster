#!/bin/sh

#  stop-backup.sh
#  
#
#  Created by Markus Tratschitt on 03.04.25.
#  
osascript -e 'display dialog "Backup wirklich abbrechen?" buttons {"Abbrechen", "Abbrechen!"} default button "Abbrechen"' | grep "Abbrechen!" && tmutil stopbackup
