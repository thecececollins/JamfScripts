#!/bin/sh

# Resource: https://www.jamf.com/jamf-nation/discussions/21095/restarting-computer-within-jamf-helper-script

# Grab icon image from specified URL and place into /tmp
/usr/bin/curl -s -o /tmp/lock_icon.png http://core0.staticworld.net/images/article/2014/11/security-and-privacy-icon-100529575-large.png
loggedInUser=$(stat -f%Su /dev/console)
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
description="There is a critical security update available for your [Company Name] issued computer. To perform the update, select 'UPDATE' below and the security update will begin to run. Once complete, you will be prompted to restart immediately. If you are unable to perform this update at the moment, please select 'Cancel.'

*Please save all working documents before selecting 'UPDATE.'

If you require assistance, please contact the Helpdesk by phone at <PhoneNumber> or by email at <EmailAddress>."

button1="UPDATE"
button2="Cancel"
icon="/tmp/lock_icon.png"
title="Critical: Apple Security Updates Available"
alignDescription="left" 
alignHeading="center"
defaultButton="2"
timeout="900"

# JAMF Helper window as it appears for targeted computers
userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -timeout "$timeout" -defaultButton "$defaultButton" -icon "$icon" -description "$description" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1" -button2 "$button2")

# If user selects "UPDATE"
if [ "$userChoice" == "0" ]; then
	echo "User clicked UPDATE; now downloading and installing all available updates."
	# Install ALL available software and security updates
	softwareupdate --install --all
	# Present user with 60 second countdown to restart computer; user may opt out of restart
	osascript -e 'tell app "loginwindow" to «event aevtrrst»'
# If user selects "Cancel"
elif [ "$userChoice" == "2" ]; then
	echo "User clicked Cancel or timeout was reached; now exiting."
	exit 0    
fi
