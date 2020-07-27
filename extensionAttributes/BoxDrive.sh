#!/bin/sh
##############################################################################
# A script to collect the version of Box Drive currently installed.          #
# If Box Drive is not installed "Not Installed" will return back.            #
##############################################################################

RESULT="Not Installed"

if [ -f "/Applications/Box.app/Contents/Info.plist" ]; then
	RESULT=$(defaults read "/Applications/Box.app/Contents/Info.plist" CFBundleVersion)
fi
echo "<result>$RESULT</result>"
exit 0
