#!/bin/sh

#  clear-log.sh
#  
#
#  Created by Markus Tratschitt on 03.04.25.
#  
> "$HOME/Library/Logs/BackupBooster.log"
osascript -e 'display notification "Logfile wurde geleert." with title "Time Machine Monitor"'
