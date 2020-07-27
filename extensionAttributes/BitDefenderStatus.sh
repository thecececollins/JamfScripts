#!/bin/sh
#########################################################################################
# A script to collect the version of BitDefender Endpoint Security currently running. #
# If BitDefender Endpoint Security is not installed "Not Installed" will return back.   #
#########################################################################################

RESULT="Not Installed"
PROCESS="Endpoint Security for Mac"

#Check to see if BitDefender Endpoint Security is installed
plist="/Library/Bitdefender/AVP/EndpointSecurityforMac.app/Contents/Info.plist"

if [[ -f "$plist" ]] && pgrep $PROCESS; then    
	RESULT=`/usr/bin/defaults read /Library/Bitdefender/AVP/EndpointSecurityforMac.app/Contents/Info.plist CFBundleShortVersionString`
	echo "<result>Running</result>"

elif [[ -f "$plist" ]] && ! pgrep $PROCESS; then
	RESULT=`/usr/bin/defaults read /Library/Bitdefender/AVP/EndpointSecurityforMac.app/Contents/Info.plist CFBundleShortVersionString`
	echo "<result>Not Running</result>"

else  echo "<result>Not Installed</result>"
fi

exit 0
