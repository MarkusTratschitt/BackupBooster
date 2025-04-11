#!/bin/sh

#  pause-backup.sh
#  
#
#  Created by Markus Tratschitt on 03.04.25.
#
APPLESCRIPT=$(osascript <<EOD
display dialog "Backup wirklich pausieren?" buttons {"Abbrechen", "Pausieren"} default button "Abbrechen"
EOD
)

# Nur fortfahren, wenn "Pausieren" gewählt wurde
if echo "$APPLESCRIPT" | grep -q "Pausieren"; then
  osascript -e 'do shell script "launchctl unload /System/Library/LaunchDaemons/com.apple.backupd-auto.plist" with administrator privileges'
fi

