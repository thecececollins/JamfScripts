#!/bin/sh
################################################################################
# A script to collect the version of Cisco AnyConnect VPN currently installed. #
# If Cisco AnyConnect VPN is not installed "Not Installed" will return back.   #
################################################################################

RESULT="Not Installed"


#Check to see if Cisco AnyConnect is installed
plist="/Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app/Contents/Info.plist"

if [[ -f "$plist" ]]; then    
    RESULT=`/usr/bin/defaults read /Applications/Cisco/Cisco\ AnyConnect\ Secure\ Mobility\ Client.app/Contents/Info.plist CFBundleShortVersionString`
fi

echo "<result>$RESULT</result>"
exit 0
