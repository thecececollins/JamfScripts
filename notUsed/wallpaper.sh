#!/bin/bash
# $3 is the logged in user - default for most policies.  
sudo -u $3 /usr/bin/osascript <<ENDofOSAscript
tell Application "Finder"
set the desktop picture to {"Library:Desktop Pictures:XXXXXX.jpg"} as alias
end tell
ENDofOSAscript
exit 0
