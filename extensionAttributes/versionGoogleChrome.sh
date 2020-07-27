#!/bin/sh
##############################################################################
# A script to collect the version of Google Chrome currently installed.      #
# If Google Chrome is not installed "Not Installed" will return back.        #
##############################################################################

RESULT="Not Installed"

FILE=/Applications/Google\ Chrome.app/Contents/Info.plist
if [ -f "$FILE" ]; then
	RESULT=$(defaults read /Applications/Google\ Chrome.app/Contents/Info.plist CFBundleShortVersionString)
fi

echo "<result>$RESULT</result>"
exit 0
