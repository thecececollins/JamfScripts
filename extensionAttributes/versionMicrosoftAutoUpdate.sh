#!/bin/bash
###############################################################################
# A script to collect the version of Microsoft AutoUpdate currently installed.#
# If Microsoft AutoUpdate is not installed "Not Installed" will return back.  #
###############################################################################

RESULT="Not Installed"

if [ -f /Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/Info.plist ]; then
	RESULT=$(defaults read /Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/Info.plist CFBundleShortVersionString)
fi
echo "<result>$RESULT</result>"
exit 0
