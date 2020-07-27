#!/bin/sh
#################################################################################################
# A script to collect the version of Adobe Creative Cloud Desktop currently installed.          #
# If Adobe Creative Cloud Desktop is not installed "Not Installed" will return back.            #
#################################################################################################

RESULT="Not Installed"

if [ -s "/Applications/Utilities/Adobe Creative Cloud/ACC/Creative Cloud.app" ]; then
    RESULT=$(defaults read /Applications/Utilities/Adobe\ Creative\ Cloud/ACC/Creative\ Cloud.app/Contents/Info.plist CFBundleShortVersionString)
fi
echo "<result>$RESULT</result>"
exit 0
