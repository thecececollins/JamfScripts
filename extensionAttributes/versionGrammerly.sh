#!/bin/sh
##############################################################################
# A script to collect the version of Grammarly currently installed. 		 #
# If Grammarly is not installed, "Not Installed" will return back.           #
##############################################################################

RESULT="Not Installed"

if [ -f "/Applications/Grammarly.app/Contents/Info.plist" ]; then
	RESULT=$(defaults read "/Applications/Grammarly.app/Contents/Info.plist" CFBundleVersion)
fi

echo "<result>$RESULT</result>"

exit 0
