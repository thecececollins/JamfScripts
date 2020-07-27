#!/bin/sh
#########################################################################################
# A script to collect the version of BitDefender Endpoint Security currently installed. #
# If BitDefender Endpoint Security is not installed "Not Installed" will return back.   #
#########################################################################################


#Check to see if BitDefender Endpoint Security is installed
plist="/Library/Bitdefender/AVP/EndpointSecurityforMac.app/Contents/Info.plist"

if [[ -f "$plist" ]]; then    
	RESULT=`/usr/bin/defaults read /Library/Bitdefender/AVP/EndpointSecurityforMac.app/Contents/Info.plist CFBundleShortVersionString`
	echo "<result>$RESULT</result>"

else  echo "<result>Not Installed</result>"
fi

exit 0
