#!/bin/sh
##############################################################################
# A script to collect the version of GitHub Desktop currently installed.      #
# If GitHub Desktop is not installed "Not Installed" will return back.        #
##############################################################################

RESULT="Not Installed"

FILE=/Applications/GitHub\ Desktop.app/Contents/Info.plist
if [ -f "$FILE" ]; then
	RESULT=$(defaults read /Applications/GitHub\ Desktop.app/Contents/Info.plist  CFBundleVersion)
fi

echo "<result>$RESULT</result>"
exit 0
