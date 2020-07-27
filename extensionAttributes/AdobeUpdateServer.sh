#!/bin/sh
########################################################################################
# A script to collect the version of Adobe Update Server currently installed.          #
# If Adobe Update Server is not installed "Not Installed" will return back.            #
########################################################################################

RESULT="Not Installed"
updaterConfigFile="/Library/Application Support/Adobe/AAMUpdater/1.0/AdobeUpdater.Overrides"

if [ -f "$updaterConfigFile" ]; then
RESULT=$(/bin/cat "$updaterConfigFile" | grep -m 1 "Domain" | sed -e 's/<[^>]*>//g' | sed 's:http\://::g' | awk '{print $1}')
fi
echo "<result>$RESULT</result>"
exit 0
	
